using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Flipbook : MonoBehaviour
{    
    float frameCount = 1;
    public int columns = 1, rows = 1;
    public float frameRate = 1;
    public bool isLoop = false;
    public bool autoPlay = false;
    public float textureScale = 1;

    Material material;
    bool isPlay = false;
    
    float _time = 0;
    float Time
    {
        get
        {
            return _time;
        }

        set
        {
            _time = value;
            material.SetFloat("_Frame", _time);
        }
    }

    private void Awake()
    {
        var img = this.GetComponent<Image>();
        img.material = new Material(Shader.Find("Hidden/FlipbookImage"));        
        img.material.SetTexture("_MainTex", img.sprite.texture);
        img.sprite = null;
        img.material.SetInt("_Columns", columns);
        img.material.SetInt("_Rows", rows);
        img.material.SetFloat("_TextureSize", textureScale);
        frameCount = columns * rows - 1;
        material = img.material;
        
    }

    private void OnEnable()
    {
        if (autoPlay) isPlay = true;
    }

    private void OnDisable()
    {
        isPlay = false;
        Time = 0;
        material.SetFloat("_Frame", 0);
    }

    void Update()
    {
        if (isPlay)
        {
            Time += UnityEngine.Time.deltaTime * frameRate;
            if(!isLoop && frameCount <= Time)
            {
                Time = frameCount;
                isPlay = false;
            }
        }                
    }

    public void Play()
    {
        isPlay = true;
        Time = 0;
    }
}
