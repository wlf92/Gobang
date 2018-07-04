package game

import (
	"errors"
	"fmt"

	"../proto"

	"github.com/davyxu/cellnet"
)

var steps []proto.Step
var chessTB [8][8]int32
var currChair int32

func init() {
	currChair = 0
}

func HandleMsg(ev cellnet.Event) {
	switch msg := ev.Message().(type) {
	case *proto.PutReq:
		fmt.Println("message recv ", msg.X, msg.Y)

		ev.Session().Send(&proto.PutAck{
			X:         2,
			Y:         3,
			PutChair:  1,
			NextChair: 0,
		})

	}
}

func checkStepLeagal(x, y int32) bool {
	if x < 0 || x >= 8 || y < 0 || y >= 8 {
		return false
	}
	return true
}

func AddStep(chair, x, y int32) error {
	if checkStepLeagal(x, y) == false {
		return errors.New("位置信息错误")
	}
	if chessTB[x][y] != 0 {
		return errors.New("该区域已落子")
	}
	if chair != currChair {
		return errors.New("当前不是你操作，请耐心等待")
	}

	var step proto.Step
	step.X = x
	step.Y = y

	steps = append(steps, proto.Step{chair, x, y})
	chessTB[x][y] = chair + 1

	currChair = (currChair + 1) % 2

	return nil
}

func GetLastStep() proto.Step {
	return steps[len(steps)-1]
}

func GetNextChair() int32 {
	return currChair
}

func GetSteps() *[]proto.Step {
	return &steps
}
