float barX = 250.0;
float speed = 5.0;
Bar bar;
Ball ball;
Block[] blocks = new Block[9];

void setup() {
	size(600, 800);
	smooth();
	frameRate(120);

	bar = new Bar(250);

	ball = new Ball(width/2, height/2);

	blocks[0] = new Block(37.5, 25);
	blocks[1] = new Block(225, 25);
	blocks[2] = new Block(412.5, 25);

	blocks[3] = new Block(37.5, 100);
	blocks[4] = new Block(225, 100);
	blocks[5] = new Block(412.5, 100);
	
	blocks[6] = new Block(37.5, 175);
	blocks[7] = new Block(225, 175);
	blocks[8] = new Block(412.5, 175);	
}

void draw() {
	background(255);

	bar.display();

	ball.update();
	ball.display();

	for(int i = 0; i < blocks.length; i++){
		blocks[i].display();
	}

	/* ボールがブロックに触れているとき反射 */
	for(int i = 0; i < blocks.length; i++){
		/* ブロックに当たっている？ */
		if(blocks[i].isTouchedByBall(ball.getX(), ball.getY())){
			/* どの壁に当たっている？ */
			switch (blocks[i].getTouchedWall(ball.getX(), ball.getY())) {
				case 1:
					ball.refrectAtY();
					ball.update();
					blocks[i].reduceDurability();
					break;
				case 2:
					ball.refrectAtX();
					ball.update();
					blocks[i].reduceDurability();
					break;
			}
		}
	}

	if(keyPressed && key == 'a') bar.moveLeft();
	if(keyPressed && key == 'd') bar.moveRight();
}

class Block {
	float x, y;
	float durability = 5;

	Block(float _x, float _y){
		x = _x;
		y = _y;
	}

	boolean isTouchedByBall(float ballX, float ballY) {
		/* 耐久地が0の場合当たり判定を消す */
		if(durability != 0) {
			/* ボールがブロック(縦横+1pxずつ)の範囲内に存在するか */
			if(this.x - 1 <= ballX && ballX <= this.x + 151){
				if(this.y - 1 <= ballY && ballY <= this.y + 51){
					return true;
				}
			}
		}
		return false;
	}

	/* 自分にボールが当たっているかを確認 */
	int getTouchedWall(float ballX, float ballY) {
		if(this.x - 1 == ballX || this.x + 151 == ballX){
			if(this.y -1  <= ballY && ballY <= this.y + 51){
				return 1;
			}
		}
		if(this.y - 1 == ballY || this.y + 51 == ballY){
			if(this.x -1  <= ballX && ballX <= this.x + 151){
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
		fill(#00ffff);
		rect(x, y, 150, 50);
	}
}

class Bar {
	float x, speed = 5;
	
	Bar(float _x){
		x = _x;
	}
	void changeSpeed(){
		/* ToDo */
		speed = 10;
	}
	void moveLeft(){
		x -= speed;
		if(x <= 0) x = 0;
	}
	void moveRight(){
		x += speed;
		if(width - 100 <= x) x = width - 100;
	}
	/* バーを描画 */
	void display() {
		fill(#00ff00);
		rect(x, 700, 100, 10);
	}
}

class Ball {
	float x, y;
	float vx = 0.25;
	float vy = -0.5;

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

	/* ボールの位置を更新 */
	void update(){
		x += vx;
		y += vy;
	}

	/* ボールを表示 */
	void display(){
		imageMode(CENTER);
		fill(#000000);
		ellipse(x, y, 5, 5);
	}

	float getX(){
		return x;
	}

	float getY(){
		return y;
	}
}