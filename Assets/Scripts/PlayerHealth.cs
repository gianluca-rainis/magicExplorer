using UnityEngine;
using UnityEngine.SceneManagement;

public class PlayerHealth : MonoBehaviour
{
    public int maxHP = 3;
    public float currentHP;
    public float damageImmortalTime = 2f;
    [SerializeField] private string gameOverSceneName = "GameOver";

    public System.Action onHealthChanged;

    private float lastDamageTime = -Mathf.Infinity;
    private bool gameOverTriggered;

    void Start()
    {
        currentHP = maxHP;
        onHealthChanged?.Invoke();
    }

    public void TakeDamage(float damage)
    {
        if (Time.time < lastDamageTime + damageImmortalTime)
        {
            return;
        }

        lastDamageTime = Time.time;
        currentHP -= damage;

        if (currentHP < 0)
        {
            currentHP = 0;
        }

        if (IsDead())
        {
            TriggerGameOver();
        }

        onHealthChanged?.Invoke();
    }

    public void Heal(float amount)
    {
        currentHP += amount;

        if (currentHP > maxHP)
        {
            currentHP = maxHP;
        }

        onHealthChanged?.Invoke();
    }

    public bool IsDead()
    {
        return currentHP <= 0;
    }

    private void TriggerGameOver()
    {
        if (gameOverTriggered)
        {
            return;
        }

        gameOverTriggered = true;

        SceneManager.LoadScene(gameOverSceneName);
        return;
    }
}