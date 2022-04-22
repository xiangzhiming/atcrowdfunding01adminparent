package com.atguigu.crowd.mvc.handler;

import com.atguigu.crowd.entity.Menu;
import com.atguigu.crowd.service.api.MenuService;
import com.atguigu.crowd.util.ResultEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Controller
public class MenuHandler {

    @Autowired
    private MenuService menuService;

    @ResponseBody
    @RequestMapping("menu/remove.json")
    public ResultEntity<String> removeMenu(Integer id) {

        menuService.removeMenu(id);

        return ResultEntity.successWithoutData();
    }

    @ResponseBody
    @RequestMapping("/menu/update.json")
    public ResultEntity<String> updateMenu(Menu menu) {

        menuService.updateMenu(menu);


        return ResultEntity.successWithoutData();
    }

    @ResponseBody
    @RequestMapping("/menu/save.json")
    public ResultEntity<String> saveMenu(Menu menu) throws InterruptedException {
        System.out.println("接收到请求");

        Thread.sleep(2000);

        menuService.saveMenu(menu);

        return ResultEntity.successWithoutData();
    }

    @ResponseBody
    @RequestMapping("/menu/get/whole/tree.json")
    public ResultEntity<Menu> getWholeTreeNew() {

        // 1查询全部的Menu对象
        List<Menu> menuList = menuService.getAll();

        // 2声明一个变量用来储存找到的根节点
        Menu root = null;

        // 3创建Map对象用来存储id和Menu对象的对应关系便于查找父节点
        Map<Integer, Menu> menuMap = new HashMap<>();

        // 4遍历menuList填充menuMap
        for (Menu menu : menuList) {

            Integer id = menu.getId();
            menuMap.put(id, menu);
        }

        // 5再次遍历menuList查找根节点，组装父子节点
        for (Menu menu : menuList) {

            // 6获取当前menu对象的pid属性值
            Integer pid = menu.getPid();

            // 如果pid为null，判定为根节点
            if (pid == null) {
                root = menu;
                // 8如果当前节点是根节点，那么肯定没有父节点，不必继续执行
                continue;
            }
            // 9如果pid不为null，说明当前节点有父节点，那么可以根据pid查找到menuMap中查找对应的Menu对象
            Menu father = menuMap.get(pid);

            // 10将当前节点存入父节点的children集合
            father.getChildren().add(menu);
        }

        // 11经过上面的运算，根节点包含了整个树形结构，返回根节点就是返回整个树
        return ResultEntity.successWithData(root);
    }

    public ResultEntity<Menu> getWholeTreeOld() {

        // 1查询全部的Menu对象
        List<Menu> menuList = menuService.getAll();

        // 2声明一个变量用来储存找到的根节点
        Menu root = null;

        // 3遍历menuList
        for (Menu menu : menuList) {

            // 4获取当前menu对象的pid属性值
            Integer pid = menu.getPid();

            // 5检查pid是否为null
            if (pid == null) {

                // 6把当前正在遍历的这个menu对象赋值给root
                root = menu;

                // 7停止本次循环，继续执行下一次循环
                continue;
            }

            // 8如果pid不为null，说明当前节点有父节点，找到父节点就可以进行组装，建立父子关系
            for (Menu maybeFather:menuList) {

                // 9获取maybeFather的id属性
                Integer id = maybeFather.getId();

                // 10将子节点的pid和疑似父节点的id进行比较
                if (Objects.equals(pid, id)) {

                    // 11将子节点存入父节点的children集合
                    maybeFather.getChildren().add(menu);

                    // 12找到即可停止运行循环
                    break;
                }
            }
        }
        // 13将组装的树形结构（也就是根节点对象）返回给浏览器
        return ResultEntity.successWithData(root);
    }

}
