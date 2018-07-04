package db_sql

import (
	"time"
)

type IUserInfo interface {
}

type UserInfo struct {
	Account    string `gorm:"primary_key"`
	Password   string
	Score      int
	NickName   string `gorm:"default:'blue'"`
	CreateTime time.Time
	LoginTime  time.Time `gorm:"default:NOW()"`
}

func (user *UserInfo) Test() {

}
