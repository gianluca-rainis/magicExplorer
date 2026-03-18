using UnityEngine;

public class Enemy : MonoBehaviour
{
    public float speed = 2f;
    public float damage = 1f;
    public int maxHP = 3;
    public float defense = 3f;
    public float collisionPushSpeed = 2f;
    private float spellKnockbackSlideDuration = 0.10f;
    private float minChaseDistance = 0.05f;
    private bool preventPhysicsKnockback = true;

    private const float movementEpsilon = 0.0001f;
    private int currentHP;

    private Transform player;
    private Rigidbody2D enemyRigidbody;

    private Animator animator;
    private Vector2 movement;
    private Vector2 lastFacingDirection = Vector2.right;
    private Vector2 spellKnockbackRemaining;
    private float spellKnockbackTimeRemaining;

    void Start()
    {
        GameObject playerObject = GameObject.FindGameObjectWithTag("Player");
        
        if (playerObject != null)
        {
            player = playerObject.transform;
        }

        enemyRigidbody = GetComponent<Rigidbody2D>();

        if (enemyRigidbody != null && preventPhysicsKnockback)
        {
            enemyRigidbody.gravityScale = 0f;
            enemyRigidbody.freezeRotation = true;
            enemyRigidbody.linearVelocity = Vector2.zero;
            enemyRigidbody.angularVelocity = 0f;
        }

        animator = GetComponent<Animator>();
        currentHP = maxHP;
    }

    void Update()
    {
        if (player == null)
        {
            return;
        }

        Vector2 currentPosition = enemyRigidbody != null ? enemyRigidbody.position : (Vector2)transform.position;
        Vector2 toPlayer = (Vector2)player.position - currentPosition;
        float minChaseDistanceSqr = minChaseDistance * minChaseDistance;

        if (toPlayer.sqrMagnitude > minChaseDistanceSqr)
        {
            movement = toPlayer.normalized;
        }
        else
        {
            movement = Vector2.zero;
        }

        if (movement != Vector2.zero)
        {
            lastFacingDirection = movement.normalized;
        }

        Vector2 animDirection = GetCardinalDirection(lastFacingDirection);

        if (animator != null)
        {
            bool isMoving = movement.sqrMagnitude > movementEpsilon;

            animator.SetFloat("Horizontal", animDirection.x);
            animator.SetFloat("Vertical", animDirection.y);
            animator.SetBool("Moving", isMoving);
        }

        if (animDirection.x < 0)
        {
            transform.localScale = new Vector3(-1.3f, 1.3f, 1);
        }
        else if (animDirection.x > 0)
        {
            transform.localScale = new Vector3(1.3f, 1.3f, 1);
        }
    }

    void FixedUpdate()
    {
        if (player == null)
        {
            return;
        }

        Vector2 knockbackDisplacement = Vector2.zero;

        if (spellKnockbackTimeRemaining > 0f && spellKnockbackRemaining.sqrMagnitude > movementEpsilon)
        {
            float fractionThisStep = Mathf.Clamp01(Time.fixedDeltaTime / spellKnockbackTimeRemaining);
            knockbackDisplacement = spellKnockbackRemaining * fractionThisStep;
            spellKnockbackRemaining -= knockbackDisplacement;
            spellKnockbackTimeRemaining -= Time.fixedDeltaTime;

            if (spellKnockbackTimeRemaining <= 0f)
            {
                spellKnockbackTimeRemaining = 0f;
                spellKnockbackRemaining = Vector2.zero;
            }
        }

        Vector2 totalDisplacement = movement * speed * Time.fixedDeltaTime + knockbackDisplacement;

        if (enemyRigidbody != null)
        {
            enemyRigidbody.MovePosition(enemyRigidbody.position + totalDisplacement);

            if (preventPhysicsKnockback)
            {
                enemyRigidbody.linearVelocity = Vector2.zero;
                enemyRigidbody.angularVelocity = 0f;
            }

            return;
        }

        transform.position += (Vector3)totalDisplacement;
    }

    private void OnCollisionStay2D(Collision2D collision)
    {
        if (collision.gameObject.CompareTag("Player"))
        {
            collision.gameObject.GetComponent<PlayerHealth>()?.TakeDamage(damage);

            PlayerController playerController = collision.gameObject.GetComponent<PlayerController>();
            Rigidbody2D playerRigidbody = collision.rigidbody;
            float playerPushPower = playerController != null ? playerController.pushPower : 0f;

            Vector2 directionEnemyFromPlayer = ((Vector2)transform.position - (Vector2)collision.transform.position).normalized;
            
            if (directionEnemyFromPlayer == Vector2.zero)
            {
                directionEnemyFromPlayer = movement == Vector2.zero ? Vector2.right : movement.normalized;
            }

            float pushStep = collisionPushSpeed * Time.fixedDeltaTime;

            if (playerPushPower >= defense)
            {
                PushTarget(enemyRigidbody, transform, directionEnemyFromPlayer, pushStep);
            }
            else
            {
                PushTarget(playerRigidbody, collision.transform, -directionEnemyFromPlayer, pushStep);
            }
        }
    }

    public void TakeDamage(int amount)
    {
        currentHP -= amount;

        if (currentHP <= 0)
        {
            Die();
        }
    }

    public void ApplySpellImpact(int amount, Vector2 spellDirection, float spellKnockback)
    {
        TakeDamage(amount);

        if (currentHP <= 0)
        {
            return;
        }

        float effectiveKnockback = Mathf.Max(0f, spellKnockback - defense);
        
        if (effectiveKnockback <= 0f)
        {
            return;
        }

        if (spellDirection.sqrMagnitude <= movementEpsilon)
        {
            return;
        }

        Vector2 knockbackDirection = spellDirection.normalized;
        Vector2 additionalKnockback = knockbackDirection * effectiveKnockback;

        if (spellKnockbackSlideDuration <= 0f)
        {
            spellKnockbackRemaining += additionalKnockback;
            spellKnockbackTimeRemaining = Time.fixedDeltaTime;
            return;
        }

        spellKnockbackRemaining += additionalKnockback;
        spellKnockbackTimeRemaining = Mathf.Max(spellKnockbackTimeRemaining, spellKnockbackSlideDuration);
    }

    void Die()
    {
        Destroy(gameObject);
    }

    private Vector2 GetCardinalDirection(Vector2 direction)
    {
        if (direction.sqrMagnitude <= movementEpsilon)
        {
            return Vector2.down;
        }

        if (Mathf.Abs(direction.x) > Mathf.Abs(direction.y))
        {
            return new Vector2(Mathf.Sign(direction.x), 0f);
        }

        return new Vector2(0f, Mathf.Sign(direction.y));
    }

    private void PushTarget(Rigidbody2D targetRigidbody, Transform targetTransform, Vector2 direction, float pushStep)
    {
        if (direction == Vector2.zero || pushStep <= 0f)
        {
            return;
        }

        Vector2 displacement = direction.normalized * pushStep;

        if (targetRigidbody != null)
        {
            targetRigidbody.MovePosition(targetRigidbody.position + displacement);
            return;
        }

        targetTransform.position += (Vector3)displacement;
    }
}