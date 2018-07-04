package db_sql

import (
	"fmt"
	"time"

	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/mysql"
)

func init() {
	db, err := gorm.Open("mysql", "root:123456@/game?charset=utf8&parseTime=True&loc=Local")
	if err != nil {
		fmt.Println(err)
		return
	}

	db.DropTableIfExists(&UserInfo{})
	db.CreateTable(&UserInfo{})
	db.Create(&UserInfo{Account: "test001", Password: "666666", Score: 200, CreateTime: time.Now()})
	db.Create(&UserInfo{Account: "test002", Password: "777777", Score: 200, CreateTime: time.Now()})
	db.Close()

}

func Test() {
	db, err := gorm.Open("mysql", "root:123456@/game?charset=utf8&parseTime=True&loc=Local")
	if err != nil {
		fmt.Println(err)
		return
	}

	var users []UserInfo
	db.Find(&users)

	for _, item := range users {
		fmt.Println(item.Account, item.Password, item.Score)
	}

	db.Close()
}
