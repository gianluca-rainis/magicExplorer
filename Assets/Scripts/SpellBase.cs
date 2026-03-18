using UnityEngine;

public class SpellBase : MonoBehaviour
{
    public int damage = 1;
    public float spellKnockback = 2f;
    public float speed = 5f;
    public float duration = 2f;
    public float recastTimeGap = 5f;
    private float spriteAngleOffset = 0f;
    protected virtual bool ShouldRotateWithDirection => true;
    protected virtual bool ShouldDestroyOnWallCollision => true;

    protected Vector2 direction;
    private Rigidbody2D spellRigidbody;
    private Collider2D[] spellColliders;
    private readonly Collider2D[] overlapBuffer = new Collider2D[16];
    private ContactFilter2D overlapFilter;

    protected virtual void Awake()
    {
        spellRigidbody = GetComponent<Rigidbody2D>();
        spellColliders = GetComponentsInChildren<Collider2D>();
        overlapFilter.useLayerMask = true;
        overlapFilter.layerMask = Physics2D.AllLayers;
        overlapFilter.useTriggers = true;

        foreach (Collider2D spellCollider in spellColliders)
        {
            spellCollider.isTrigger = true;
        }

        IgnorePlayerCollisions();
    }

    public virtual void Initialize(Vector2 direction)
    {
        this.direction = direction.normalized;

        if (ShouldRotateWithDirection)
        {
            RotateToDirection();
        }

        if (spellRigidbody != null)
        {
            spellRigidbody.linearVelocity = this.direction * speed;
        }

        Destroy(gameObject, duration);
    }

    private void RotateToDirection()
    {
        if (direction == Vector2.zero)
        {
            return;
        }

        float angle = Mathf.Atan2(direction.y, direction.x) * Mathf.Rad2Deg;
        transform.rotation = Quaternion.Euler(0f, 0f, angle + spriteAngleOffset);
    }

    public void DamageLevelUp(int newDamage)
    {
        damage = newDamage;
    }

    public void SpeedLevelUp(float newSpeed)
    {
        speed = newSpeed;
    }

    public void DurationLevelUp(float newDuration)
    {
        duration = newDuration;
    }

    protected virtual void Update()
    {
        if (spellRigidbody == null)
        {
            Move();
            CheckWallOverlapWithoutRigidbody();
        }
    }

    protected virtual void FixedUpdate()
    {
        if (spellRigidbody == null)
        {
            return;
        }

        spellRigidbody.linearVelocity = direction * speed;
    }

    protected virtual void Move()
    {
        transform.Translate((Vector3)(direction * speed * Time.deltaTime), Space.World);
    }

    private void CheckWallOverlapWithoutRigidbody()
    {
        foreach (Collider2D spellCollider in spellColliders)
        {
            if (spellCollider == null)
            {
                continue;
            }

            Bounds bounds = spellCollider.bounds;
            int hitCount = Physics2D.OverlapBox(bounds.center, bounds.size, 0f, overlapFilter, overlapBuffer);

            for (int i = 0; i < hitCount; i++)
            {
                Collider2D hit = overlapBuffer[i];
                if (hit == null || hit.transform.IsChildOf(transform))
                {
                    continue;
                }

                if (ShouldDestroyOnWallCollision && hit.CompareTag("Wall"))
                {
                    Destroy(gameObject);
                    return;
                }
            }
        }
    }

    protected virtual void OnTriggerEnter2D(Collider2D other)
    {
        if (TryIgnoreSpellCollision(other))
        {
            return;
        }

        HandleImpact(other.gameObject);
    }

    protected virtual void OnCollisionEnter2D(Collision2D collision)
    {
        if (TryIgnoreSpellCollision(collision.collider))
        {
            return;
        }

        HandleImpact(collision.gameObject);
    }

    private void HandleImpact(GameObject otherObject)
    {
        if (otherObject.GetComponentInParent<SpellBase>() != null)
        {
            return;
        }

        if (otherObject.CompareTag("Enemy"))
        {
            Enemy enemy = otherObject.GetComponent<Enemy>();

            if (enemy != null)
            {
                enemy.ApplySpellImpact(damage, direction, spellKnockback);
            }

            Destroy(gameObject);
            
            return;
        }

        if (ShouldDestroyOnWallCollision && otherObject.CompareTag("Wall"))
        {
            Destroy(gameObject);
        }
    }

    private bool TryIgnoreSpellCollision(Collider2D otherCollider)
    {
        SpellBase otherSpell = otherCollider.GetComponentInParent<SpellBase>();
        
        if (otherSpell == null || otherSpell == this)
        {
            return false;
        }

        Collider2D[] myColliders = spellColliders;
        Collider2D[] otherColliders = otherSpell.GetComponentsInChildren<Collider2D>();

        foreach (Collider2D myCollider in myColliders)
        {
            foreach (Collider2D other in otherColliders)
            {
                Physics2D.IgnoreCollision(myCollider, other, true);
            }
        }

        return true;
    }

    private void IgnorePlayerCollisions()
    {
        GameObject[] players = GameObject.FindGameObjectsWithTag("Player");
        
        foreach (GameObject player in players)
        {
            Collider2D[] playerColliders = player.GetComponentsInChildren<Collider2D>();

            foreach (Collider2D spellCollider in spellColliders)
            {
                foreach (Collider2D playerCollider in playerColliders)
                {
                    Physics2D.IgnoreCollision(spellCollider, playerCollider, true);
                }
            }
        }
    }
}