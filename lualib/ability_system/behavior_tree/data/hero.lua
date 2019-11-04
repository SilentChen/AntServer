return {
  name = [[Selector]],
  desc = [[英雄AI]],
  children = {
    {
      name = [[Sequence]],
      desc = [[攻击]],
      children = {
        {
          name = [[FindEnemy]],
          desc = [[查找范围敌人]],
          args = {w=100,h=50,},
          output = {"enemy",},
        },
        {
          name = [[Attack]],
          desc = [[普通攻击]],
          input = {"enemy",},
          args = {skillid = 101,},
        },
        {
          name = [[Wait]],
          desc = [[后摇]],
          args = {time = 10,},
        },
      },
    },
    {
      name = [[Sequence]],
      desc = [[移动]],
      children = {
        {
          name = [[FindEnemy]],
          desc = [[查找范围敌人]],
          args = {w=1000,h=500,},
          output = {"enemy",},
        },
        {
          name = [[MoveToTarget]],
          desc = [[移动到目标]],
          input = {"enemy",},
        },
      },
    },
    {
      name = [[Sequence]],
      desc = [[逃跑]],
      children = {
        {
          name = [[GetHp]],
          desc = [[获取当前血量]],
          output = {"hp",},
        },
        {
          name = [[Cmpare]],
          desc = [[小于100]],
          input = {"hp",},
          args = {lt = 50,},
        },
        {
          name = [[MoveToPos]],
          desc = [[移动到坐标]],
          args = {x = 0,y = 0,},
        },
      },
    },
    {
      name = [[Idle]],
      desc = [[待机]],
    },
  },
}