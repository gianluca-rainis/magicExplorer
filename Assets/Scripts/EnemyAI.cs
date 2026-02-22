using UnityEngine;

public class EnemyAI : MonoBehaviour
{
    public float speed = 2f;
    public float damage = 1f;
    private Transform player;
    
    private float playerImmortalTime = 2f;
    private float lastDamageTime;

    void Start()
    {
        player = GameObject.FindGameObjectWithTag("Player").transform;
    }

    void Update()
    {
        if (player == null)
        {
            return;
        }

        Vector2 direction = (player.position - transform.position).normalized;
        transform.position += (Vector3)direction * speed * Time.deltaTime;
    }

    private void OnCollisionStay2D(Collision2D collision)
    {
        if (collision.gameObject.CompareTag("Player"))
        {
            if (Time.time > lastDamageTime + playerImmortalTime)
            {
                collision.gameObject.GetComponent<PlayerHealth>()?.TakeDamage(damage);
                lastDamageTime = Time.time;
            }
        }
    }
}