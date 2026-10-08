/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

// Create the 3D scene
var scene = new THREE.Scene();

// Create camera
var camera = new THREE.PerspectiveCamera(
    75,
    window.innerWidth / window.innerHeight,
    0.1,
    1000
);

// Put camera away from the cube
camera.position.z = 5;

// Create renderer
var renderer = new THREE.WebGLRenderer({
    antialias: true
});

renderer.setSize(window.innerWidth, window.innerHeight);

// Add renderer to webpage
document.body.appendChild(renderer.domElement);


// Create cube
var geometry = new THREE.BoxGeometry(2, 2, 2);

var material = new THREE.MeshStandardMaterial({
    color: 0x00ff00
});

var cube = new THREE.Mesh(geometry, material);

scene.add(cube);


// Create light
var light = new THREE.DirectionalLight(0xffffff, 2);

light.position.set(5, 5, 5);

scene.add(light);


// Add ambient light
var ambientLight = new THREE.AmbientLight(0xffffff, 0.5);

scene.add(ambientLight);


// Animation
function animate() {

    requestAnimationFrame(animate);

    cube.rotation.x += 0.01;
    cube.rotation.y += 0.01;

    renderer.render(scene, camera);
}

animate();


// Handle browser resize
window.addEventListener("resize", function() {

    camera.aspect = window.innerWidth / window.innerHeight;

    camera.updateProjectionMatrix();

    renderer.setSize(
        window.innerWidth,
        window.innerHeight
    );

});
