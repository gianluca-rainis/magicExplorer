using UnityEngine;

public class DoorScript : MonoBehaviour
{
    public GameObject nextRoom; // Reference to the next room to load
    public Transform playerSpawnPoint; // Where the player should spawn in the next room

    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
        {
            transform.parent.gameObject.SetActive(false);
            nextRoom.SetActive(true);

            if (playerSpawnPoint != null)
            {
                other.transform.position = playerSpawnPoint.position;
            }
        }
    }
}