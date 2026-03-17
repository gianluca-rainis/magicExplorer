using UnityEngine;

public class DoorScript : MonoBehaviour
{
    public GameObject currentRoom; // Reference to the current room
    public GameObject nextRoom; // Reference to the next room to load
    public Transform playerSpawnPoint; // Where the player should spawn in the next room

    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
        {
            DestroyAllActiveSpells();

            nextRoom.SetActive(true);

            if (playerSpawnPoint != null)
            {
                other.transform.position = playerSpawnPoint.position;
            }

            currentRoom.SetActive(false);
        }
    }

    private void DestroyAllActiveSpells()
    {
        SpellBase[] activeSpells = FindObjectsByType<SpellBase>(FindObjectsSortMode.None);
        
        foreach (SpellBase spell in activeSpells)
        {
            Destroy(spell.gameObject);
        }
    }
}