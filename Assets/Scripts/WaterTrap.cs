using UnityEngine;

public class WaterTrap : SpellBase
{
    protected override bool ShouldRotateWithDirection => false;
    protected override bool ShouldDestroyOnWallCollision => false;

    /* public new int damage = 2;
    public new float speed = 0f;
    public new float duration = 10f; */

    protected override void OnTriggerEnter2D(Collider2D other)
    {
        if (other.CompareTag("Enemy"))
        {
            other.GetComponent<EnemyHealth>()?.TakeDamage(damage);
            Destroy(gameObject);
        }
    }

    protected override void Move()
    {
        // WaterTrap doesn't move
    }
}