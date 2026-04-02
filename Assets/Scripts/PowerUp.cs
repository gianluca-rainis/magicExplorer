using UnityEngine;

public class PowerUp : MonoBehaviour
{
    public enum PowerUpType
    {
        Cure,
        Health,
        Spell
    }

    public PowerUpType powerUpType;

    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
        {
            PlayerHealth playerHealth = other.GetComponent<PlayerHealth>();
            PlayerController playerController = other.GetComponent<PlayerController>();

            switch (powerUpType)
            {
                case PowerUpType.Cure:
                    if (playerHealth != null)
                    {
                        playerHealth.Heal(1);
                    }

                    break;
                case PowerUpType.Health:
                    if (playerHealth != null)
                    {
                        playerHealth.maxHP += 1;
                        playerHealth.Heal(playerHealth.maxHP);
                    }

                    break;
                case PowerUpType.Spell:
                    if (playerController != null)
                    {
                        SpellPowerup(playerController.GetRandomSpell());
                    }

                    break;
            }

            Destroy(gameObject);
        }
    }

    public void SpellPowerup(SpellBase spell)
    {
        if (spell == null)
        {
            return;
        }

        spell.level += 1;
        spell.DamageLevelUp(spell.damage + 1);
        spell.KnockbackLevelUp(spell.spellKnockback + 0.5f);
        spell.SpeedLevelUp(spell.speed + 1f);
        spell.DurationLevelUp(spell.duration + 0.5f);
        spell.RecastTimeGapLevelUp(spell.recastTimeGap - 0.3f);

        PauseMenuPanel pauseMenuPanel = FindFirstObjectByType<PauseMenuPanel>();

        if (pauseMenuPanel != null)
        {
            pauseMenuPanel.UpdateSelectedSpellLevelText(spell);
        }
    }
}