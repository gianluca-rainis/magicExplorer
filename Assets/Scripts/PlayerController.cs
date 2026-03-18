using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerController : MonoBehaviour
{
    public float moveSpeed = 5f;
    public float pushPower = 3f;
    [SerializeField] private FireBolt fireboltPrefab;
    [SerializeField] private AirWall airwallPrefab;
    [SerializeField] private WaterTrap watertrapPrefab;
    [SerializeField] private float spellSpawnDistance = 0.75f;

    private Rigidbody2D rb;
    private Animator animator;

    private const float movementEpsilon = 0.0001f;

    private Vector2 movement;
    private Vector2 lastFacingDirection = Vector2.right;
    private float nextFireboltCastTime;
    private float nextAirwallCastTime;
    private float nextWatertrapCastTime;

    void Start()
    {
        rb = GetComponent<Rigidbody2D>();
        animator = GetComponent<Animator>();
    }

    public void OnMove(InputAction.CallbackContext context)
    {
        movement = context.ReadValue<Vector2>();
    }

    void Update()
    {
        if (movement != Vector2.zero)
        {
            lastFacingDirection = movement.normalized;
        }

        Vector2 facingDirection = lastFacingDirection == Vector2.zero ? Vector2.right : lastFacingDirection;
        Vector2 animDirection = movement.sqrMagnitude > movementEpsilon ? GetCardinalDirection(movement) : GetCardinalDirection(facingDirection);
        bool isMoving = movement.sqrMagnitude > movementEpsilon;

        animator.SetFloat("Horizontal", animDirection.x);
        animator.SetFloat("Vertical", animDirection.y);
        animator.SetBool("Moving", isMoving);

        if (movement.x < 0)
        {
            transform.localScale = new Vector3(-0.8f, 0.8f, 1);
        }
        else if (movement.x > 0)
        {
            transform.localScale = new Vector3(0.8f, 0.8f, 1);
        }

        if (Keyboard.current != null && Keyboard.current.jKey.wasPressedThisFrame)
        {
            CastFirebolt();
        }

        if (Keyboard.current != null && Keyboard.current.kKey.wasPressedThisFrame)
        {
            CastAirwall();
        }

        if (Keyboard.current != null && Keyboard.current.lKey.wasPressedThisFrame)
        {
            CastWatertrap();
        }
    }

    void FixedUpdate()
    {
        rb.linearVelocity = movement * moveSpeed;
    }

    private void CastFirebolt()
    {
        TryCastSpell(fireboltPrefab, ref nextFireboltCastTime);
    }

    private void CastAirwall()
    {
        TryCastSpell(airwallPrefab, ref nextAirwallCastTime);
    }

    private void CastWatertrap()
    {
        TryCastSpell(watertrapPrefab, ref nextWatertrapCastTime);
    }

    private void TryCastSpell<TSpell>(TSpell spellPrefab, ref float nextCastTime) where TSpell : SpellBase
    {
        if (spellPrefab == null || Time.time < nextCastTime)
        {
            return;
        }

        Vector2 castDirection = lastFacingDirection == Vector2.zero ? Vector2.right : lastFacingDirection;
        Vector3 spawnPosition = transform.position + (Vector3)(castDirection * spellSpawnDistance);
        TSpell spawnedSpell = Instantiate(spellPrefab, spawnPosition, Quaternion.identity);
        spawnedSpell.Initialize(castDirection);

        nextCastTime = Time.time + Mathf.Max(0f, spellPrefab.recastTimeGap);
    }

    private Vector2 GetCardinalDirection(Vector2 direction)
    {
        if (Mathf.Abs(direction.x) > Mathf.Abs(direction.y))
        {
            return new Vector2(Mathf.Sign(direction.x), 0f);
        }

        if (Mathf.Abs(direction.y) > 0f)
        {
            return new Vector2(0f, Mathf.Sign(direction.y));
        }

        return Vector2.right;
    }
}