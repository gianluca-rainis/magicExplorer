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
            Enemy enemy = other.GetComponent<Enemy>();
            
            if (enemy != null)
            {
                enemy.ApplySpellImpact(damage, direction, spellKnockback);
            }

            Destroy(gameObject);
        }
    }

    protected override void Move()
    {
        // WaterTrap doesn't move
    }
}