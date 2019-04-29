using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateLight : MonoBehaviour
{
    private Vector3 pivotPoint = new Vector3(0,0,0);

    public float radius = 5;
    // Start is called before the first frame update
    void Start()
    {
        pivotPoint = transform.position;
        float newX = pivotPoint.x;
        newX += radius;
        transform.position = new Vector3(newX, pivotPoint.y, pivotPoint.z);
    }

    // Update is called once per frame
    void Update()
    {
        transform.RotateAround(pivotPoint, Vector3.up, 20 * Time.deltaTime);
    }
}
