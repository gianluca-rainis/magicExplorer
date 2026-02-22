using UnityEngine;

public class SpellBase : MonoBehaviour
{
    public int damage = 1;
    public float speed = 5f;
    public float duration = 2f;

    protected Vector2 direction;

    public virtual void Initialize(Vector2 direction)
    {
        this.direction = direction.normalized;
        Destroy(gameObject, duration);
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
        Move();
    }

    protected virtual void Move()
    {
        transform.Translate(direction * speed * Time.deltaTime);
    }

    protected virtual void OnTriggerEnter2D(Collider2D other)
    {
        if (other.CompareTag("Enemy"))
        {
            other.GetComponent<EnemyHealth>()?.TakeDamage(damage);
            Destroy(gameObject);
        }

        if (other.CompareTag("Wall"))
        {
            Destroy(gameObject);
        }
    }
}