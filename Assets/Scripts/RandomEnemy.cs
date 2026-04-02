using UnityEngine;

public class RandomEnemy : MonoBehaviour
{
    public Enemy[] enemies;
    private Enemy spawnedEnemy;

    public void Start()
    {
        TrySpawnEnemy();
    }

    private void OnEnable()
    {
        TrySpawnEnemy();
    }

    private void TrySpawnEnemy()
    {
        if (spawnedEnemy != null)
        {
            return;
        }

        if (enemies == null || enemies.Length == 0)
        {
            return;
        }

        int randomIndex = Random.Range(0, enemies.Length);

        Enemy randomEnemy = enemies[randomIndex];

        spawnedEnemy = Instantiate(randomEnemy, transform.position, Quaternion.identity, transform.parent);
    }
}