// Name, UAA ID NO.
// Tyler Boozer, 31038416
// Masa Hu,
// Brian Kapala,

// CSCE 385 Computer Graphics
// Fall 2015
// 09/20/2015

//=========================================================//
//=========================================================//
// Supporting library
// http://www.wikihow.com/Install-Mesa-%28OpenGL%29-on-Linux-Mint
//=========================================================//
//=========================================================//
// ---WINDOWs ONLY---
//#include <windows.h>					// included in all Windows apps
//#include <winuser.h>          // Windows constants
//#include <gl/gl.h>						// OpenGL include
//#include <gl/glu.h>
//#include <GL/openglut.h>
//=========================================================//
//=========================================================//
// ---LINUX or UNIX ONLY---
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include <GL/glut.h>
#include <GL/glu.h>
#include <GL/gl.h>

//=========================================================//
//=========================================================//
// person position in the environment
void move_camera(int specialKey,char normalKey);
void update_camera();

GLdouble  g_playerPos[] = { 0, 10, -10 };//{ 0.0, 0.5, 10.0 };
GLfloat   g_robotPos[] = {0,0,0};
GLfloat   g_robotRadius = 2.0;
GLdouble  g_lookAt[] = { 0.0, 0.0, 0.0 };
GLfloat   g_viewAngle = 90;
GLfloat   g_elevationAngle = -25.0;
GLfloat   change_colorG  = 1.0;
GLfloat   change_colorG1 = 1.0;
GLfloat   change_colorG2 = 1.0;
GLfloat   change_colorG3 = 1.0;
GLfloat   change_colorG4 = 1.0;
GLfloat   change_colorG5 = 1.0;
GLfloat   change_colorR  = 0.0;
GLfloat   change_colorR1 = 0.0;
GLfloat   change_colorR2 = 0.0;
GLfloat   change_colorR3 = 0.0;
GLfloat   change_colorR4 = 0.0;
GLfloat   change_colorR5 = 0.0;
GLfloat radius = 10;
float rad = 3.141592654/2;
const float DEFAULT_SPEED   = 0.4f;
//=========================================================//
//=========================================================//
GLvoid  DrawGround();
GLvoid  DrawNormalObjects(GLfloat rotation);
GLvoid  DrawWireframeObjects(GLfloat rotation);
GLvoid  DrawFlatshadedObjects(GLfloat rotation);

GLfloat findDistance(GLfloat x1, GLfloat y1, GLfloat z1,
						GLfloat x2, GLfloat y2, GLfloat z2);
// Collision detection (distances from robot to collidable objects)
	GLfloat distance_co1;
	GLfloat distance_co2;
	GLfloat distance_co3;
	GLfloat distance_co4;
	GLfloat distance_co5;
//=========================================================================//
//=========================================================================//
// Robotic Functionality / Necessities
static void moveLegs(double legSpeed);
static void rotationWholePos();
static void rotationWholeNeg();
static void moveRight();
static void moveLeft();
static void moveUp();
static void moveDown();
static bool goForward = false;

float changeSpeed = 8;
float rotateForWalkMotion = 0;
float rotateUpperTorso_degrees = 0;
float moveTestX = 0;
float moveTestY = 0;
float moveTestZ= 0;
float radiusc = 0;
float zmovement = 0;
float rotatePointer_degrees = 0;
double testVar = 0;
double pastlimit = 0;
//=========================================================================//
//=========================================================================//
static int slices = 4;
static int stacks = 4;
static double irad = .25;
static double orad = 1.0;
//=========================================================================//
//=========================================================================//
// quadric objects
void init_dados(void);
void setup_sceneEffects(void);
GLUquadricObj *g_normalObject     = NULL;
GLUquadricObj *g_wireframeObject  = NULL;
GLUquadricObj *g_flatshadedObject = NULL;
void cleanUP_data(void);

const int   WORLD_SIZE = 250;
//=========================================================//
//=========================================================//
static void drawSolidTetrahedron(void)
    { glutSolidTetrahedron (); }
static void drawWireTetrahedron(void)
    { glutWireTetrahedron (); }
static void drawSolidCube(void)
    { glutSolidCube(1); }
static void drawWireCube(void)
    { glutWireCube(1); }
static void drawSolidOctahedron(void)
    { glutSolidOctahedron (); }
static void drawWireOctahedron(void)
    { glutWireOctahedron (); }
static void drawSolidDodecahedron(void)
    { glutSolidDodecahedron (); }
static void drawWireDodecahedron(void)
    { glutWireDodecahedron (); }
static void drawSolidIcosahedron(void)
    { glutSolidIcosahedron (); }
static void drawWireIcosahedron(void)
    { glutWireIcosahedron (); }
static void drawSolidTeapot(void)
    { glutSolidTeapot(1); }
static void drawWireTeapot(void)
    { glutWireTeapot(1); }
static void drawSolidTorus(void)
    { glutSolidTorus(irad,orad,slices,stacks); }
static void drawWireTorus(void)
    { glutWireTorus (irad,orad,slices,stacks); }
static void drawSolidSphere(void)
    { glutSolidSphere(1,slices,stacks); }
static void drawWireSphere(void)
    { glutWireSphere(1,slices,stacks); }
static void drawSolidCone(void)
    { glutSolidCone(1,1,slices,stacks); }
static void drawWireCone(void)
    { glutWireCone(1,1,slices,stacks); }
static void drawSolidCylinder(void)
{	gluCylinder(g_flatshadedObject,1,1,1,slices,stacks);}
static void drawWireCylinder(void)
{	gluCylinder(g_wireframeObject,1,1,1,slices,stacks);}
//=========================================================================//
//=========================================================================//
// This structure defines an entry in our function-table.
typedef struct
{
    const char * const name;
    void (*solid) (void);
    void (*wire)  (void);
} entry;
//=========================================================================//
//=========================================================================//
#define ENTRY(e) {#e, drawSolid##e, drawWire##e}
static const entry table [] =
{
    ENTRY (Tetrahedron),
    ENTRY (Cube),
    ENTRY (Octahedron),
    ENTRY (Dodecahedron),
    ENTRY (Icosahedron),
    ENTRY (Teapot),
    ENTRY (Torus),
    ENTRY (Sphere),
    ENTRY (Cone),
	ENTRY (Cylinder) //9
};
#undef ENTRY
//=========================================================//
//=========================================================//

// Green Cylinder - Collidable object - co1
GLfloat co1_radius = 5.0;
GLfloat co1_x = 30.0;
GLfloat co1_y = 12.0;
GLfloat co1_z = 10.0;

// Green Cylinder - Collidable object - co2
GLfloat co2_radius = 15.0;
GLfloat co2_x = -30.0;
GLfloat co2_y = 12.0;
GLfloat co2_z = -30.0;

// Green Cylinder - Collidable object - co3
GLfloat co3_radius = 5.0;
GLfloat co3_x = 30.0;
GLfloat co3_y = 12.0;
GLfloat co3_z = -25.0;

// Green Cone - Collidable object - co4
GLfloat co4_radius = 9.0;
GLfloat co4_x = -10.0;
GLfloat co4_y = 0.0;
GLfloat co4_z = 30.0;

// Inverted Green Cone - Collidable object - co5
GLfloat co5_radius = 4.5; 	// lowered since the sphere is run from the base of inv cone.
GLfloat co5_x = 40.0;
GLfloat co5_y = 10.0;
GLfloat co5_z = 40.0;

//=========================================================//
//=========================================================//


GLfloat findDistance(GLfloat x1, GLfloat y1, GLfloat z1,
						GLfloat x2, GLfloat y2, GLfloat z2)
{
	GLfloat distance = 0;

	distance = sqrt(( (x1 - x2) * (x1-x2) )
					+ ((z1 - z2) * (z1 - z2)));
	return distance;
}

static void resize(int width, int height)
{
    const float ar = (float) width / (float) height;

    glViewport(0, 0, width, height);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    if( ar > .5 )
        glFrustum( -ar, ar, -1.0, 1.0, 2.0, 100.0 );
    else
        glFrustum( -1.0, 1.0, -1/ar, 1/ar, 2.0, 100.0 );
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity() ;
}
//=========================================================//
//=========================================================//
GLvoid DrawGround()
{ // enable blending for anti-aliased lines
  glEnable(GL_BLEND);

  // set the color to a bright blue
    glColor3f(0.5f, 0.7f, 1.0f);

    // draw the lines
    glBegin(GL_LINES);
      for (int x = -WORLD_SIZE; x < WORLD_SIZE; x += 25)
      {
        glVertex3i(x, 0, -WORLD_SIZE);
        glVertex3i(x, 0, WORLD_SIZE);
      }

      for (int z = -WORLD_SIZE; z < WORLD_SIZE; z += 25)
      {
        glVertex3i(-WORLD_SIZE, 0, z);
        glVertex3i(WORLD_SIZE, 0, z);
      }
    glEnd();

  // turn blending off
  glDisable(GL_BLEND);
}
//=========================================================//
//=========================================================//
GLvoid DrawNormalObjects(GLfloat rotation)
{
  // make sure the random color values we get are the same every time
  srand(200);

  distance_co1 = findDistance(g_robotPos[0],g_robotPos[1],g_robotPos[2],
								co1_x,co1_y, co1_z);
  distance_co2 = findDistance(g_robotPos[0],g_robotPos[1],g_robotPos[2],
								co2_x,co2_y, co2_z);
  distance_co3 = findDistance(g_robotPos[0],g_robotPos[1],g_robotPos[2],
								co3_x,co3_y, co3_z);
  distance_co4 = findDistance(g_robotPos[0],g_robotPos[1],g_robotPos[2],
								co4_x,co4_y, co4_z);
  distance_co5 = findDistance(g_robotPos[0],g_robotPos[1],g_robotPos[2],
								co5_x,co5_y, co5_z);

  	  // Collision detection
  	  if(distance_co1 <= g_robotRadius + co1_radius)
  	  {
  		  // Red::Collision occurrence
  		  change_colorG1 = 0.0;
  		  change_colorR1 = 1.0;
  		  goForward = false;
  	  }
  	  else
  	  {
  		  // Regular color:: no collision
  		  change_colorG1 = 1.0;
  		  change_colorR1 = 0.0;
  	  }

  	  // Checks collision between robot and collidable object 2 (co2)
  	  if(distance_co2 <= g_robotRadius + co2_radius)
  	  {
  		  // Red::Collision occurrence
  		  change_colorG2 = 0.0;
  		  change_colorR2 = 1.0;
  		 goForward = false;
  	  }
  	  else
  	  {
  		  // Regular color:: no collision
  		  change_colorG2 = 1.0;
  		  change_colorR2 = 0.0;
  	  }

	  // Checks collision between robot and collidable object 3 (co3)
	  if(distance_co3 <= g_robotRadius + co3_radius)
	  {
		  // Red::Collision occurrence
		  change_colorG3 = 0.0;
		  change_colorR3 = 1.0;
		  goForward = false;
	  }
	  else
	  {
		  // Regular color:: no collision
		  change_colorG3 = 1.0;
		  change_colorR3 = 0.0;
	  }

	  // Checks collision between robot and collidable object 4 (co4)
	  if(distance_co4 <= g_robotRadius + co4_radius)
	  {
		  // Red::Collision occurrence
		  change_colorG4 = 0.0;
		  change_colorR4 = 1.0;
		  goForward = false;
	  }
	  else
	  {
		  // Regular color:: no collision
		  change_colorG4 = 1.0;
		  change_colorR4 = 0.0;
	  }

	  // Checks collision between robot and collidable object 5 (co5)
	  if(distance_co5 <= g_robotRadius + co5_radius)
	  {
		  // Red::Collision occurrence
		  change_colorG5 = 0.0;
		  change_colorR5 = 1.0;
		  goForward = false;
	  }
	  else
	  {
		  // Regular color:: no collision
		  change_colorG5 = 1.0;
		  change_colorR5 = 0.0;
	  }

  glPushAttrib(GL_CURRENT_BIT);

  glPopAttrib();  		// restore the previous color values
}
//=========================================================//
//=========================================================//
static void createLeg(int leftright) // Put a 1 for one side -1 for another side.
{
	// Leg A
	glPushMatrix();
	{
		// Rotates Leg A upper
		glRotatef(10, 0, 0, 1);// Set's the initial rotation
		glRotatef(rotateForWalkMotion*leftright, 0, 0, 1); // Used for motion.
		// End rotates Leg A upper.
		glPushMatrix(); // The data for Leg A upper.
		{
			glTranslatef(0, -.75, .5*leftright); // Initial Placement of Leg A Upper
			glPushMatrix(); // Set's the data for Leg A Lower hinge
			{
				glTranslatef(0, -1, .5); // Set's the placement for the rotation for Leg A Lower.
				glPushMatrix(); // The data for Leg A lower
				{
					glRotatef(-rotateForWalkMotion*leftright, 0, 0, 1); // Rotates Leg A lower
					glRotatef(-20, 0, 0, 1); // Initial placement of Leg A lower on the end of leg A Upper.
					glTranslatef(0, -1, -.5); // Placement of the Leg A Lower from it's rotation point.

					glPushMatrix(); // The data for Leg B
					{
						glRotatef(10, 0, 0, 1);
						glTranslatef(.25, -1, 0); // Placement of the Leg B Lower from it's rotation point.
						glScalef(1.5, .5, .5);// Sets the size of Leg B lower.
						table[1].solid();// Set's the shape for leg B lower
						//glColor3d(1, 1, 0);// Sets the color for Leg B lower.
					}glPopMatrix();// Used to keep the translate separate of Leg B

					glScalef(0.5, 2, .5);// Sets the size of Leg A lower.
					table[1].solid();// Set's the shape for leg A lower
					glColor3d(1, 1, 0);// Sets the color for Leg a lower.
				}glPopMatrix();// Used to keep the translate separate of Leg A
			}glPopMatrix(); // End data for Leg A lower
			glColor3d(0, 1, 0); // Yellow (Upper Leg A)
			glScalef(0.5, 2, .5);// Sets the size for Leg A Upper.
			table[1].solid(); // Sets the shape for leg A Upper.
		}glPopMatrix(); // End data for leg A Upper
	}glPopMatrix();
}

static void createGuns()
{
	glPushMatrix(); // The data for Leg B
	{
		glPushMatrix();
		glScalef(1, .25, .25);
		table[1].solid();
		glPopMatrix();
		//glTranslatef(0, 2.5, 0); // Placement of the Leg B Lower from it's rotation point.
		glScalef(2, .1, .1);// Sets the size of Leg B lower.
		glPushMatrix();
		glRotatef(90, 0, 1, 0); // rotate
		table[9].solid();// Set's the shape for leg B lower
		glPopMatrix();
	}glPopMatrix();
}

static void createArm(int leftright) // Put a 1 for one side -1 for another side.
{
	glPushMatrix();
	{
		glTranslatef(0, 2.0, 1.5*leftright);
		glRotatef(180, 0, 1, 0);// Set's the initial rotation
		glRotatef(10, 0, 0, 1);// Set's the initial rotation
		glRotatef(rotateForWalkMotion*leftright, 0, 0, 1); // Used for motion.
		glPushMatrix(); // The data for Leg A upper.
		{
			glTranslatef(0, -.75, .5*leftright); // Initial Placement of Leg A Upper

			glPushMatrix();
			glTranslatef(0, 0, -.35*leftright);
			glRotatef(270, 0, 0, 1);
			createGuns();
			glPopMatrix();

			glPushMatrix(); // Set's the data for Leg A Lower hinge
			{
				glTranslatef(0, -1, .5); // Set's the placement for the rotation for Leg A Lower.
				glPushMatrix(); // The data for Leg A lower
				{
					{


					}// insert code here for hand guns
					glRotatef(-rotateForWalkMotion*leftright, 0, 0, 1); // Rotates Leg A lower
					glRotatef(-100, 0, 0, 1); // Initial placement of Leg A lower on the end of leg A Upper.
					glTranslatef(0, -.5, -.5); // Placement of the Leg A Lower from it's rotation point
					glScalef(0.5, 1.5, .5);// Sets the size of Leg A lower.
					table[1].solid();// Set's the shape for leg A lower
					glColor3d(1, 1, 0);// Sets the color for Leg a lower.
				}glPopMatrix();// Used to keep the translate separate of Leg A
			}glPopMatrix(); // End data for Leg A lower
			glColor3d(0, 1, 0); // Yellow (Upper Leg A)
			glScalef(0.5, 1.5, .5);// Sets the size for Leg A Upper.
			table[1].solid(); // Sets the shape for leg A Upper.
		}glPopMatrix(); // End data for leg A Upper
	}glPopMatrix();
}

static void createHead()
{
	glPushMatrix(); // The data for Leg B
	{
		glPushMatrix(); // The data for Leg B
		{
			glTranslatef(0, 3, 0); // Placement of the Leg B Lower from it's rotation point.
			glScalef(1, 1, 1);// Sets the size of Leg B lower.
			table[1].solid();// Set's the shape for leg B lower
			glColor3d(1, 1, 0);// Sets the color for Leg B lower.
		}
		glPopMatrix();// Used to keep the translate separate of Leg B
		glTranslatef(0, 2.5, 0); // Placement of the Leg B Lower from it's rotation point.
		glScalef(.25, 1,.25);// Sets the size of Leg B lower.
		glRotatef(90, 1, 0, 0); // rotate
		table[9].solid();// Set's the shape for leg B lower
		glColor3d(1, 1, 0);// Sets the color for Leg B lower.
	}glPopMatrix();// Used to keep the translate separate of Leg B

}

static void createRobot(int ViewPosX, int ViewPosZ)
{
	glPushMatrix();
	glPushMatrix();
	{
		glColor3d(1, 0, 1);// Purple
		glTranslatef(g_robotPos[0],3,g_robotPos[2]);
		glRotatef(-g_viewAngle, 0.0, 1, 0.0); // rotate
		glPushMatrix();
		{
			glRotatef(rotateUpperTorso_degrees, 0.0, 1, 0.0); // rotate
			createHead();
			createArm(1);
			createArm(-1);
			glTranslatef(0, 1.25, 0);// Set Position Figure
			glColor3d(1, 0, 1);// Purple
			glScalef(.5, 2, 1.5);
			table[1].solid();

		}glPopMatrix();
		createLeg(1);
		createLeg(-1);
		glScalef(.5,.5,.5);
		table[1].solid();
	}glPopMatrix();
	glPopMatrix();
}

static void moveLegs(double legSpeed)
{

	if (pastlimit == false)
	{
		rotateForWalkMotion=rotateForWalkMotion+legSpeed;
		testVar=testVar+legSpeed;
		if (testVar > 20)
		{
			pastlimit = true;
		}
	}
	else if (pastlimit == true)
	{
		rotateForWalkMotion = rotateForWalkMotion - legSpeed;
		testVar= testVar-legSpeed;
		if (testVar < -20)
		{
			pastlimit = false;
		}
	}
}

static void rotationWholePos()
{
	if (g_viewAngle >= 360)
		g_viewAngle = 0;
	g_viewAngle = g_viewAngle + 5;
}

static void rotationWholeNeg()
{
	if (g_viewAngle <= 0)
		g_viewAngle = 360;
	g_viewAngle = g_viewAngle - 4;
}

static void moveRight()
{
	if (g_viewAngle == 0 || g_viewAngle == 360)
	{
	}
	else if (g_viewAngle < 360 && g_viewAngle > 180)
	{
		rotationWholePos();
	}
	else if (g_viewAngle > 0 && g_viewAngle <= 180)
	{
		rotationWholeNeg();
	}
}

static void moveLeft()
{
	if (g_viewAngle == 180)
	{
	}
	else if ((g_viewAngle == 360 && g_viewAngle < 180) || (g_viewAngle >= 0 && g_viewAngle < 180))
	{
		rotationWholePos();
	}
	else if (g_viewAngle < 360 && g_viewAngle > 180)
	{
		rotationWholeNeg();
	}
}

static void moveUp()
{
	if (g_viewAngle == 90)
	{
	}
	else if (g_viewAngle > 90 && g_viewAngle < 270)
	{
		rotationWholeNeg();
	}
	else if (g_viewAngle < 90 || g_viewAngle >= 270)
	{
		rotationWholePos();
	}
}

static void moveDown()
{
	if (g_viewAngle == 270)
	{
	}
	else if (g_viewAngle > 90 && g_viewAngle < 270)
	{
		rotationWholePos();
	}
	else if (g_viewAngle != 270)
	{
		rotationWholeNeg();
	}
}

//=========================================================//
//=========================================================//

GLvoid DrawFlatshadedObjects(GLfloat rotation)
{
  glShadeModel(GL_FLAT);
  // used locally for animation
  static GLfloat scaleFactor = 1.0f;
  static GLfloat scaleFactorDelta = 0.001f;

  scaleFactor += scaleFactorDelta;

  if (scaleFactor >= 1.5f || scaleFactor <= 1.0f)
    scaleFactorDelta = -scaleFactorDelta;


  // make sure the random color values we get are the same every time
  srand(400);

  // save the existing color properties
  glPushAttrib(GL_CURRENT_BIT);

  // restore previous attributes
  glPopAttrib();
  glShadeModel(GL_SMOOTH);
}
//=========================================================//
//=========================================================//
GLvoid DrawWireframeObjects(GLfloat rotation)
{
  // make sure the random color values we get are the same every time
	srand(300);

  // save the existing color properties
	glPushAttrib(GL_CURRENT_BIT);

  // enable blending to get anti-aliased lines.
	glEnable(GL_BLEND);
	glDisable(GL_DEPTH_TEST);
  	  glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

  	  	  // co_1 -Cylinder- Radius = 5.0, Height = 12.0, Center = (30, 12, -10)
  	  	  glPushMatrix();
  	  	  	 	glMateriali(GL_FRONT_AND_BACK, GL_SHININESS, rand() % 128);
  	  	  	 	glColor3f(change_colorR1, change_colorG1, 0.0f);
  	  	  	    glTranslatef(30.0, 12, 10.0);
  	  	  	    glRotatef(90.0, 1.0, 0.0, 0.0);
  				gluCylinder(g_wireframeObject, 5.0, 5.0, 12.0, 32, 4);
  		  glPopMatrix();

  		  // co_2 -Cylinder- Radius = 15.0, Height = 12.0, Center = (-30, 12, -30)
  		  glPushMatrix();
  		  	  	glMateriali(GL_FRONT_AND_BACK, GL_SHININESS, rand() % 128);
  		  	  	glColor3f(change_colorR2, change_colorG2, 0.0f);
  		  	  	glTranslatef(co2_x, co2_y, co2_z);
  		  	  	glRotatef(90.0, 1.0, 0.0, 0.0);
  		  	  	gluCylinder(g_wireframeObject, 15.0, 15.0, 12.0, 32, 4);
  		  glPopMatrix();

  		// co_3 -Cylinder- Radius = 5.0, Height = 12.0, Center = (30, 12, -25)
  		glPushMatrix();
  		 	 	glMateriali(GL_FRONT_AND_BACK, GL_SHININESS, rand() % 128);
  		  		glColor3f(change_colorR3, change_colorG3, 0.0f);
  		  		glTranslatef(30.0, 12, -25.0);
  		  		glRotatef(90.0, 1.0, 0.0, 0.0);
  		  		gluCylinder(g_wireframeObject, 5.0, 5.0, 12.0, 32, 4);
  		glPopMatrix();

  		// co_4 -Cone- BaseRadius = 9.5, Height = 6.0, Center = (-10, 0, 30)
  		glPushMatrix();
  				glMateriali(GL_FRONT_AND_BACK, GL_SHININESS, rand() % 128);
  				glColor3f(change_colorR4, change_colorG4, 0.0f);
  				glTranslatef(-10.0, 0.0, 30.0);
  				glRotatef(-90.0, 1.0, 0.0, 0.0);
  				gluCylinder(g_wireframeObject, 9.5, 0.0, 6.0, 32, 4);
  		glPopMatrix();

  		// co_5 -Inverted Cone- BaseRadius = 7.5, Height = 10.0, Center = (40, 10, 40)
  		glPushMatrix();
  		  		glMateriali(GL_FRONT_AND_BACK, GL_SHININESS, rand() % 128);
  		  		glColor3f(change_colorR5, change_colorG5, 0.0f);
  		  		glTranslatef(40.0, 10.0, 40.0);
  		  		glRotatef(90.0, 1.0, 0.0, 0.0);
  		  		gluCylinder(g_wireframeObject, 7.5, 0.0, 10.0, 32, 4);
  		glPopMatrix();

  		// Creating the robot
		const double t = glutGet(GLUT_ELAPSED_TIME) / 1000.0;
		const double a = t*90.0;
		int ViewPosX = 0, ViewPosZ = -8;
		int limita = 0;
		int limitb = 0;
		glColor3d(0, 0, 1);
		glPushMatrix();
			createRobot(g_robotPos[0], g_robotPos[2]); // we name him starscream
			//createGuns();
	glPopMatrix();

  glDisable(GL_BLEND);
  glEnable(GL_DEPTH_TEST);    // Turn Depth Testing On

  glPopAttrib();			// restore previous attributes
}
//=========================================================//
//=========================================================//
static void display(void)
{
    update_camera();

    if(goForward)
    {
    	moveLegs(.1);

    	g_robotPos[2] += sin(rad) * 0.01;
    	g_robotPos[0] += cos(rad) * 0.01;

    	g_playerPos[2] = g_robotPos[2] - radius * sin(rad);
    	g_playerPos[0] = g_robotPos[0] - radius * cos(rad);
    }

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glEnable(GL_LIGHTING);

    // position the light
    GLfloat pos[4] = { 5.0, 5.0, 5.0, 0.0 };
    glLightfv(GL_LIGHT0, GL_POSITION, pos);

    // rotation is used for animation
    static GLfloat rotation = 0.0;

    // it's increased by one every frame
    rotation += 1.0;

    // and ranges between 0 and 360
    if (rotation > 360.0)
    {
    	rotation = 0.0;
    }
    // draw all of our objects in their normal position
    DrawNormalObjects(rotation);
    DrawWireframeObjects(rotation);
    DrawFlatshadedObjects(rotation);

    DrawGround();

    glutSwapBuffers();
}
//=========================================================//
//=========================================================//
static void keyboard(unsigned char key, int x, int y)
{ int number=-1;

    move_camera(number,key);

    glutPostRedisplay();
}
//=========================================================//
// 		Camera Functionality
//=========================================================//
void move_camera(int specialKEY,char normalKEY)
{
    // keyboard :: normal keys
    switch(normalKEY)
    {   // looking up
        case 'A':
        case 'a': g_elevationAngle += 2.0; break;
       // looking down
        case 'Z':
        case 'z': g_elevationAngle -= 2.0;  break;
		case 'd':
		case 'D': rotateUpperTorso_degrees++; break;
		case 'f':
		case 'F': rotateUpperTorso_degrees--; break;
		case 'w':
		{
			if(goForward)
				goForward = false;
			else if(!goForward)
				goForward = true;
		}
		break;

        default:
        {    break;
        }
    }

    // special :: special keys
    switch(specialKEY)
    {   // camera setup
        // check if it is moving the view to look left
        case GLUT_KEY_LEFT:
        {
			moveLegs(3);

            g_viewAngle -= 2.0;
            // calculate camera rotation angle radians
            rad =  float(3.14159 * g_viewAngle / 180.0f);
			g_playerPos[2] = g_robotPos[2] - radius * sin(rad);
            g_playerPos[0] = g_robotPos[0] - radius * cos(rad);
            break;
        }
        // check if it is moving the view to look right
        case GLUT_KEY_RIGHT:
        {
			moveLegs(3);

             g_viewAngle += 2.0;
            // calculate camera rotation angle radians
            rad =  float(3.14159 * g_viewAngle / 180.0f);
			g_playerPos[2] = g_robotPos[2] - radius * sin(rad);
            g_playerPos[0] = g_robotPos[0] - radius * cos(rad);

            break;
        }
        // pressing keys Up/Down, update coordinates "x" and "z"
        // based on speed and angle of view.
        case GLUT_KEY_UP:
        {
			moveLegs(3);

            g_robotPos[2] += sin(rad) * DEFAULT_SPEED;
			g_robotPos[0] += cos(rad) * DEFAULT_SPEED;
			g_playerPos[2] = g_robotPos[2] - radius * sin(rad);
            g_playerPos[0] = g_robotPos[0] - radius * cos(rad);


        	break;
        }
        case GLUT_KEY_DOWN:
        {
			moveLegs(3);

            g_robotPos[2] -= sin(rad) * DEFAULT_SPEED;
			g_robotPos[0] -= cos(rad) * DEFAULT_SPEED;
			g_playerPos[2] = g_robotPos[2] - radius * sin(rad);
            g_playerPos[0] = g_robotPos[0] - radius * cos(rad);
            break;
        }
        default:
        {   break;
        }
    }
}
//=========================================================//
//=========================================================//
static void special(int key, int x, int y)
{   char letter=' ';

    move_camera(key,letter);

    glutPostRedisplay();
}

//=========================================================//
//=========================================================//
static void idle(void)
{
    glutPostRedisplay();
}
//=========================================================//
//=========================================================//
void update_camera()
{
// don't allow the player to wander past the "edge of the world"
    if (g_playerPos[0] < -(WORLD_SIZE-50))
    g_playerPos[0] = -(WORLD_SIZE-50);
    if (g_playerPos[0] > (WORLD_SIZE-50))
    g_playerPos[0] = (WORLD_SIZE-50);
    if (g_playerPos[2] < -(WORLD_SIZE-50))
    g_playerPos[2] = -(WORLD_SIZE-50);
    if (g_playerPos[2] > (WORLD_SIZE-50))
    g_playerPos[2] = (WORLD_SIZE-50);

  // calculate the player's angle of rotation in radians
    float rad =  float(3.14159 * g_viewAngle / 180.0f);
    // use the players view angle to correctly set up the view matrix
    g_lookAt[0] = float(g_playerPos[0] + radius*cos(rad));
    g_lookAt[2] = float(g_playerPos[2] + radius*sin(rad));

    rad = float (3.13149 * g_elevationAngle / 180.0f);

    g_lookAt[1] = float (g_playerPos[1] + radius * sin(rad));

    // clear the modelview matrix
    glLoadIdentity();

    // setup the view matrix
    gluLookAt(g_playerPos[0], g_playerPos[1], g_playerPos[2],
              g_lookAt[0],    g_lookAt[1],    g_lookAt[2],
              0.0,            1.0,            0.0);
}
//=========================================================//
//=========================================================//
void setup_sceneEffects(void)
{
  // enable lighting
  glEnable(GL_LIGHTING);
  glEnable(GL_LIGHT0);

  // enable using glColor to change material properties
  // we'll use the default glColorMaterial setting (ambient and diffuse)
  glEnable(GL_COLOR_MATERIAL);

  // set the default blending function
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

  // set up the fog parameters for reflections
  glFogi(GL_FOG_MODE, GL_LINEAR);
  glFogf(GL_FOG_START, -100.0);
  glFogf(GL_FOG_END, 100.0);

  // enable line anti-aliasing and make the lines slightly bigger than default
  glEnable(GL_LINE_SMOOTH);
  glLineWidth(1.5f);
}
//=========================================================//
//=========================================================//
void init_dados(void)
{
  setup_sceneEffects();
  // create a normal quadric (uses default settings)
  g_normalObject = gluNewQuadric();

  g_wireframeObject = gluNewQuadric();
  gluQuadricDrawStyle(g_wireframeObject, GLU_LINE);

  // create an object that uses flat shading
  g_flatshadedObject = gluNewQuadric();
  gluQuadricNormals(g_flatshadedObject, GLU_FLAT);

}
//=========================================================//
//=========================================================//
void cleanUP_data(void)
{  // delete all quadratic objects
  if (g_normalObject)
    gluDeleteQuadric(g_normalObject);
  if (g_wireframeObject)
    gluDeleteQuadric(g_wireframeObject);
  if (g_flatshadedObject)
    gluDeleteQuadric(g_flatshadedObject);
}
//=========================================================//
//=========================================================//
int main(int argc, char *argv[])
{
    glutInitWindowSize(640,480);
    glutInitWindowPosition(40,40);
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE | GLUT_DEPTH);

    init_dados();

    glutCreateWindow("A385 Computer Graphics -- T2A : Killer Robot (Boozer, Hu, Kapala)");

    glutReshapeFunc(resize);
    glutDisplayFunc(display);
    glutKeyboardFunc(keyboard);
    glutSpecialFunc(special);
    glutIdleFunc(idle);

    // environment background color
    glClearColor(0.0,0.0,0.0,1);

    // depth effect to objects
    glEnable(GL_DEPTH_TEST);
    glDepthFunc(GL_LESS);
    // light and material in the environment
    glEnable(GL_LIGHT0);
    glEnable(GL_NORMALIZE);
    glEnable(GL_COLOR_MATERIAL);

    glutMainLoop();
    cleanUP_data();

    return EXIT_SUCCESS;
}
//=========================================================//
//=========================================================//

