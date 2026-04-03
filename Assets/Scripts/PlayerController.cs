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

    private PlayerInput playerInput;
    private InputAction fireboltAction;
    private InputAction airwallAction;
    private InputAction watertrapAction;

    private Rigidbody2D rb;
    private Animator animator;
    private FireBolt fireboltSpell;
    private AirWall airwallSpell;
    private WaterTrap watertrapSpell;

    private const float movementEpsilon = 0.0001f;

    private Vector2 movement;
    private Vector2 lastFacingDirection = Vector2.right;
    private float nextFireboltCastTime;
    private float nextAirwallCastTime;
    private float nextWatertrapCastTime;

    void Awake()
    {
        playerInput = GetComponent<PlayerInput>();

        fireboltAction = playerInput.actions["J"];
        airwallAction = playerInput.actions["K"];
        watertrapAction = playerInput.actions["L"];
    }

    void Start()
    {
        rb = GetComponent<Rigidbody2D>();
        animator = GetComponent<Animator>();

        InitializeRuntimeSpells();
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

        if (fireboltAction != null && fireboltAction.WasPressedThisFrame())
        {
            CastFirebolt();
        }

        if (airwallAction != null && airwallAction.WasPressedThisFrame())
        {
            CastAirwall();
        }

        if (watertrapAction != null && watertrapAction.WasPressedThisFrame())
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
        TryCastSpell(fireboltPrefab, fireboltSpell, ref nextFireboltCastTime);
    }

    private void CastAirwall()
    {
        TryCastSpell(airwallPrefab, airwallSpell, ref nextAirwallCastTime);
    }

    private void CastWatertrap()
    {
        TryCastSpell(watertrapPrefab, watertrapSpell, ref nextWatertrapCastTime);
    }

    private void TryCastSpell<TSpell>(TSpell spellPrefab, TSpell spellTemplate, ref float nextCastTime) where TSpell : SpellBase
    {
        if (spellPrefab == null || spellTemplate == null || Time.time < nextCastTime)
        {
            return;
        }

        Vector2 castDirection = lastFacingDirection == Vector2.zero ? Vector2.right : lastFacingDirection;
        Vector3 spawnPosition = transform.position + (Vector3)(castDirection * spellSpawnDistance);
        TSpell spawnedSpell = Instantiate(spellPrefab, spawnPosition, Quaternion.identity);
        spawnedSpell.CopyStatsFrom(spellTemplate);
        spawnedSpell.Initialize(castDirection);

        nextCastTime = Time.time + Mathf.Max(0f, spellTemplate.recastTimeGap);
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

    public SpellBase GetRandomSpell()
    {
        SpellBase[] spells = new SpellBase[] { fireboltSpell, airwallSpell, watertrapSpell };

        int randomIndex = Random.Range(0, spells.Length);
        
        return spells[randomIndex];
    }

    public FireBolt FireboltSpell => fireboltSpell;
    public AirWall AirwallSpell => airwallSpell;
    public WaterTrap WatertrapSpell => watertrapSpell;

    private void InitializeRuntimeSpells()
    {
        fireboltSpell = CreateRuntimeSpell(fireboltPrefab);
        airwallSpell = CreateRuntimeSpell(airwallPrefab);
        watertrapSpell = CreateRuntimeSpell(watertrapPrefab);
    }

    private TSpell CreateRuntimeSpell<TSpell>(TSpell spellPrefab) where TSpell : SpellBase
    {
        if (spellPrefab == null)
        {
            return null;
        }

        TSpell runtimeSpell = Instantiate(spellPrefab, Vector3.zero, Quaternion.identity, transform);
        runtimeSpell.gameObject.SetActive(false);
        runtimeSpell.CopyStatsFrom(spellPrefab);
        
        return runtimeSpell;
    }
}