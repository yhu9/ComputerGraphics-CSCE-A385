//=========================================================//
//=========================================================//
/*
Inverted Clock

Clock that pointers 1 and 2 have opposite motions.
The base should rotate on Y every time you press A++ or B--
The pointers move in oposite direction every time that was pressed C++ or D--
*/
//=========================================================//
//=========================================================//
// LINUX or UNIX ONLY
#include <stdlib.h>
#include <gl/glut.h>
//=========================================================//
//=========================================================//
#include <stdarg.h>
#include <stdio.h>
#include <math.h>

#define NUMBEROF(x) ((sizeof(x))/(sizeof(x[0])))

static int function_index;
static int slices = 36;
static int stacks = 16;
static double irad = .25;
static double orad = 1.0;

GLUquadricObj *g_normalObject     = NULL;
GLUquadricObj *g_wireframeObject  = NULL;
GLUquadricObj *g_flatshadedObject = NULL;

float changeSpeed = 1;
float rotateBaseL_degrees = 0;
float rotateBaseR_degrees = 0;
float rotateBaseW_degrees = 0;

float rotatePointer_degrees = 0;

/////////////////////////////////////////////////////////////////////////////////////////////
GLvoid drawDisk1(GLfloat rotation);
GLvoid drawDisk2(GLfloat rotation);
void init_dados(void);
void setup_sceneEffects(void);
void cleanUP_data(void);

/////////////////////////////////////////////////////////////////////////////////////////////


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
    ENTRY (Cone)//,
};
#undef ENTRY


GLvoid drawSpinner(GLfloat rotation, double x, double y, double z, double speed, double radiusa, int r, int g, int b, double translate)
{

  glPushMatrix();
    glMateriali(GL_FRONT_AND_BACK, GL_SHININESS, rand() % 128);
    glColor3ub(r, g, b);
    glTranslatef(x, y, z);
    glRotatef(rotation* radiusa * speed + translate, 0.0, 0.0, 1.0);
    glScalef(radiusa,.1,.01);
	table[7].solid();
  glPopMatrix();
}

GLvoid drawSpinnerSet(GLfloat rotation, double x, double y, double z, double speed, int r, int g, int b, double radiusa)
{
	drawSpinner( rotation,  x,  y,  z, speed, radiusa,  r,  g,  b, 0);
	drawSpinner( rotation,  x,  y,  z, speed, radiusa,  r,  g,  b, 90);
}

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

void cleanUP_data(void)
{  // delete all quadratic objects
  if (g_normalObject)
    gluDeleteQuadric(g_normalObject);
  if (g_wireframeObject)
    gluDeleteQuadric(g_wireframeObject);
  if (g_flatshadedObject)
    gluDeleteQuadric(g_flatshadedObject);
}

static void shapesPrintf (int row, int col, const char *fmt, ...)
{
    static char buf[256];
    int viewport[4];
    void *font = GLUT_BITMAP_9_BY_15;
    va_list args;

    va_start(args, fmt);
    (void) vsprintf_s (buf, fmt, args);
    va_end(args);

    glGetIntegerv(GL_VIEWPORT,viewport);

    glPushMatrix();
    glLoadIdentity();

    glMatrixMode(GL_PROJECTION);
    glPushMatrix();
    glLoadIdentity();

        glOrtho(0,viewport[2],0,viewport[3],-1,1);
    glPopMatrix();
    glMatrixMode(GL_MODELVIEW);
    glPopMatrix();
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

static void display(void)
{
	const double t = glutGet(GLUT_ELAPSED_TIME) / 1000.0;
    const double a = t*90.0;
    int ViewPosX=0,ViewPosZ=-8;
	static GLfloat rotation = 0.0;
	rotation += 0.1;

	srand(300);

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glPushAttrib(GL_CURRENT_BIT);
    glEnable(GL_LIGHTING);
	//glEnable(GL_BLEND);
    glColor3d(0,0,1);


	// Central base
	glPushMatrix();
	// placement (x-axis, y-axis, z-axis)
	glTranslatef (ViewPosX, -2.25, ViewPosZ);// Set Position Figure
	glRotatef ((GLfloat) rotateBaseW_degrees, 0.0, 0.1, 0.0); // rotate
	// placement (x-axis, y-axis, z-axis)
		glPushMatrix();
		glColor3d(.10, .50, .33);
		glScalef(0.5, 2, 0.5);
		table[1].solid ();
		glPopMatrix();

		// draw vertical bracexx
		glPushMatrix();
		glTranslatef(0, 1, 0); // Initial Placement of red stem
		glColor3d(.10, .50, .33);
			glPushMatrix();
			glScalef(4, 0.5, 0.5);
			table[1].solid();
			glPopMatrix();
		glPopMatrix();

		// draw right stem
		glPushMatrix();
		glTranslatef(1.75, 2.25, 0); // Initial Placement of right stem
		glRotatef(rotateBaseR_degrees, 0, 1, 0); // Where and how much it rotates
		glColor3d(.10, .50, .33);
			glPushMatrix();
			glScalef(0.5,2,0.5);
			table[1].solid ();
			glPopMatrix();
			glPushMatrix();
				glTranslatef(0,1,0);
				glScalef(.1,.1,2);
				table[1].solid();
			glPopMatrix();
			glPushMatrix();
				drawSpinnerSet(rotation,0,1,.3,changeSpeed, 255,255,0,1);
				drawSpinnerSet(rotation,0,1,.5,changeSpeed,0,255,255,1.3);
				drawSpinnerSet(rotation,0,1,.7,changeSpeed,255,0,255,1.6);
			glPopMatrix();
		glPopMatrix();

		// draw left stemc
		glPushMatrix();
		glTranslatef(-1.75, 2.25, 0); // Initial Placement of left stem
		glRotatef(rotateBaseL_degrees, 0, 1, 0); // Where and how much it rotates
		glColor3d(.10, .50, .33);
			glPushMatrix();
			glScalef(0.5, 2, 0.5);
			table[1].solid ();
			glPopMatrix();
			glPushMatrix();
				glTranslatef(0,1,0);
				glScalef(.1,.1,2);
				table[1].solid();
			glPopMatrix();
				drawSpinnerSet(rotation,0,1,.3,changeSpeed, 255,255,0,1);
				drawSpinnerSet(rotation,0,1,.5,changeSpeed,0,255,255,1.3);
				drawSpinnerSet(rotation,0,1,.7,changeSpeed,255,0,255,1.6);
			glPopMatrix();
		glPopMatrix();

	glPopMatrix();

	glDisable(GL_LIGHTING);
	//glDisable(GL_BLEND);
	glPopAttrib();
    glColor3d(0.1,0.1,0.4);
	glutSwapBuffers();
}

static void keyboard(unsigned char key, int x, int y)
{
	switch (key)
	{
// This is meant to set the button for the speed of the spinning.
	case '1':
		changeSpeed=1;
		break;
	case '2':
		changeSpeed=2;
		break;
	case '3':
		changeSpeed=3;
		break;
// This is meant to change the direction of the rotation of the windmills.
	// Rotates left windmill
	case 'a':
		rotateBaseL_degrees++;
		break;
	case 's':
		rotateBaseL_degrees--;
		break; 
	case 'A':
		rotateBaseL_degrees++;
		break;
	case 'S':
		rotateBaseL_degrees--;
		break;
	// Rotates right windmill
	case 'd':
		rotateBaseR_degrees++;
		break;
	case 'f':
		rotateBaseR_degrees--;
		break;
	case 'D':
		rotateBaseR_degrees++;
		break;
	case 'F':
		rotateBaseR_degrees--;
		break;
	// Rotates the base
	case 'x':
		rotateBaseW_degrees++;
		break;
	case 'c':
		rotateBaseW_degrees--;
		break;
	case 'X':
		rotateBaseW_degrees++;
		break;
	case 'C':
		rotateBaseW_degrees--;
		break;
	// The default.
    default:
        break;
    }

    glutPostRedisplay();
}

static void special(int key, int x, int y)
{
    switch (key)
    {
    case GLUT_KEY_PAGE_UP:    ++function_index; break;
    case GLUT_KEY_PAGE_DOWN:  --function_index; break;
    case GLUT_KEY_UP:         orad *= 2;        break;
    case GLUT_KEY_DOWN:       orad /= 2;        break;

    case GLUT_KEY_RIGHT:      irad *= 2;        break;
    case GLUT_KEY_LEFT:       irad /= 2;        break;

    default:
        break;
    }

    if (0 > function_index)
        function_index = NUMBEROF (table) - 1;

    if (NUMBEROF (table) <= ( unsigned )function_index)
        function_index = 0;
}

static void idle(void)
{
    glutPostRedisplay();
}

const GLfloat light_ambient[]  = { 0.0f, 0.0f, 0.0f, 1.0f };
const GLfloat light_diffuse[]  = { 1.0f, 1.0f, 1.0f, 1.0f };
const GLfloat light_specular[] = { 1.0f, 1.0f, 1.0f, 1.0f };
const GLfloat light_position[] = { 2.0f, 5.0f, 5.0f, 0.0f };

const GLfloat mat_ambient[]    = { 0.7f, 0.7f, 0.7f, 1.0f };
const GLfloat mat_diffuse[]    = { 0.8f, 0.8f, 0.8f, 1.0f };
const GLfloat mat_specular[]   = { 1.0f, 1.0f, 1.0f, 1.0f };
const GLfloat high_shininess[] = { 100.0f };

int main(int argc, char *argv[])
{
    glutInitWindowSize(640,480);
    glutInitWindowPosition(40,40);
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE | GLUT_DEPTH);
	init_dados();
    glutCreateWindow("OpenGLUT Shapes");

    glutReshapeFunc(resize);
    glutDisplayFunc(display);
    glutKeyboardFunc(keyboard);
    glutSpecialFunc(special);
    glutIdleFunc(idle);

    glClearColor(1,1,1,1);
    glEnable(GL_CULL_FACE);
    glCullFace(GL_BACK);

    glEnable(GL_DEPTH_TEST);
    glDepthFunc(GL_LESS);

    glEnable(GL_LIGHT0);
    glEnable(GL_NORMALIZE);
    glEnable(GL_COLOR_MATERIAL);
	glEnable(GL_FRONT_AND_BACK);

    glLightfv(GL_LIGHT0, GL_AMBIENT,  light_ambient);
    glLightfv(GL_LIGHT0, GL_DIFFUSE,  light_diffuse);
    glLightfv(GL_LIGHT0, GL_SPECULAR, light_specular);
    glLightfv(GL_LIGHT0, GL_POSITION, light_position);

    glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT,   mat_ambient);
    glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE,   mat_diffuse);
    glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR,  mat_specular);
    glMaterialfv(GL_FRONT_AND_BACK, GL_SHININESS, high_shininess);

    glutMainLoop();
	cleanUP_data();
    return EXIT_SUCCESS;
}

