Bar bar;
Ball ball;
Block[] blocks = new Block[9];
Wall[] walls = new Wall[4];

void setup() {
	size(600, 800);
	smooth();
	frameRate(300);

	bar = new Bar(250);

	ball = new Ball(width/2, height/2);

	blocks[0] = new Block(37.5, 25, 0);
	blocks[1] = new Block(225, 25, 0);
	blocks[2] = new Block(412.5, 25, 0);

	blocks[3] = new Block(37.5, 100, 1);
	blocks[4] = new Block(225, 100, 1);
	blocks[5] = new Block(412.5, 100, 1);
	
	blocks[6] = new Block(37.5, 175, 2);
	blocks[7] = new Block(225, 175, 2);
	blocks[8] = new Block(412.5, 175, 2);

	walls[0] = new Wall(0, 0, width, 1);
	walls[1] = new Wall(width, 0, 1, height);
	walls[2] = new Wall(0, height, width, 1);
	walls[3] = new Wall(0, 0, 1, height);
}

void draw() {
	background(255);
	/* ボールがバーに触れているとき反射 */
	if(bar.isTouchedByBall(ball.getX(), ball.getY())) {
		ball.refrectAtX();
	}
	/* ボールがブロックに触れているとき反射 */
	for(int i = 0; i < blocks.length; i++){
		/* ブロックに当たっている？ */
		if(blocks[i].isTouchedByBall(ball.getX(), ball.getY())){
			/* どの壁に当たっている？ */
			switch (blocks[i].getTouchedWall(ball.getX(), ball.getY())) {
				case 1:
					ball.refrectAtY();
					blocks[i].reduceDurability();
					println("case1");
					break;
				case 2:
					ball.refrectAtX();
					blocks[i].reduceDurability();
					println("case2");
					break;
			}
		}
	}
	for(int i = 0; i < walls.length; i++) {
		if(walls[i].isTouchedByBall(ball.getX(), ball.getY())) {
			switch (i) {
				case 0:
					ball.refrectAtX();
					break;
				case 1:
					ball.refrectAtY();
					break;
				case 2:
					ball.refrectAtX();
					break;
				case 3:
					ball.refrectAtY();
					break;
			}
		}
	}

	bar.setPosition(mouseX);
	
	/* ボール,バー,ブロックの再描画 */
	bar.display();
	ball.update();
	ball.display();
	for(int i = 0; i < blocks.length; i++){
		blocks[i].display();
	}

	/* クリアしてるかチェック */
	if(isCleard()) {
		sendClearMsg();
		noLoop();
	}
}

boolean isCleard() {
	for(int i = 0; i < blocks.length; i++) {
		if(blocks[i].getDurability() != 0) {
			return false;
		}
	}
	return true;
}

void sendClearMsg() {
	String msg = "Game Clear!";
	textSize(50);
	float msgWidth = textWidth(msg);
	fill(#000000);
	text(msg, (width/2)-(msgWidth/2), height/2);
	println(msg);
}

class Block {
	float x, y;
	float hue;
	float width = 150, height = 50;
	float durability = 2;

	Block(float _x, float _y, int _hue){
		x = _x;
		y = _y;
		hue = _hue;
	}

	boolean isTouchedByBall(float ballX, float ballY) {
		/* 耐久地が0の場合当たり判定を消す */
		if(durability != 0) {
			/* ボールがブロック(縦横+1pxずつ)の範囲内に存在するか */
			if(this.x - 1 <= ballX && ballX <= this.x + width + 1){
				if(this.y - 1 <= ballY && ballY <= this.y + height + 1){
					println("abc");
					return true;
				}
			}
		}
		return false;
	}

	/* 自分にボールが当たっているかを確認 */
	int getTouchedWall(float ballX, float ballY) {
		if(this.x - 1 == ballX || this.x + width + 1 == ballX){
			if(this.y -1  <= ballY && ballY <= this.y + height + 1){
				return 1;
			}
		}
		if(this.y - 1 == ballY || this.y + height + 1 == ballY){
			if(this.x - 1 <= ballX && ballX <= this.x + width + 1){
				return 2;
			}
		}
		return 0;
	}

	/* ブロックの耐久度を減らす */
	void reduceDurability() {
		durability--;
	}

	/* ブロックを描画 */
	void display() {
		if(durability != 0){
			colorMode(HSB, 3, 100, 100);
			fill(hue, 100, 100);
			rect(x, y, width, height);
			colorMode(RGB,256);
		}
	}

	float getDurability() {
		return durability;
	}
}

class Bar {
	float x, y = 700;
	float width = 100, height = 10;
	
	Bar(float _x){
		x = _x;
	}
	
	void setPosition(float _x) {
		x = _x;
		if(x <= 0) x = 0;
		if(600 - 100 <= x) x = 600 - 100;
	}

	boolean isTouchedByBall(float ballX, float ballY) {
		if(this.y - 1 == ballY){
			if(this.x - 1 <= ballX && ballX <= this.x + width + 1){
				return true;
			}
		}
		return false;
	}

	/* バーを描画 */
	void display() {
		fill(#00ff00);
		rect(x, y, 100, 10);
	}
}

class Ball {
	float x, y;
	float vx = 1.0;
	float vy = 1.0;

	Ball(float _x, float _y){
		x = _x;
		y = _y;
	}

	void refrectAtX() {
		vy *= -1;
	}

	void refrectAtY() {
		vx *= -1;
	}

	void changeVx() {

	}

	void changeVy() {

	}

	/* ボールの位置を更新 */
	void update(){
		x += vx;
		y += vy;
	}

	/* ボールを表示 */
	void display(){
		imageMode(CENTER);
		fill(#ffffff);
		ellipse(x, y, 10, 10);
		imageMode(CORNER);
	}

	float getX(){
		return x;
	}

	float getY(){
		return y;
	}
}

/* フィールドの壁 */
class Wall {
	float x, y, width, height;
	Wall(float _x, float _y, float _width, float _height){
		x = _x;
		y = _y;
		width = _width;
		height = _height;
	}

	boolean isTouchedByBall(float ballX, float ballY){
		if(this.x <= ballX && ballX <= this.x + width) {
			if(this.y <= ballY && ballY <= this.y + height) {
				return true;
			}
		}
		return false;
	}
}