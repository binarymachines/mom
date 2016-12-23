package com.angrysurfer.mildred.ui.javafx;

/**
 * Created by mpippins on 12/17/16.
 */

import javafx.application.Application;
import javafx.stage.*;
import javafx.scene.*;
import javafx.scene.control.*;
import javafx.fxml.FXMLLoader;
import java.net.URL;

public class MildredMonitorStage extends Application {

    public static void main(String[] args) {

        launch(args);
    }

    public void start(Stage stage) throws Exception {
        URL fxml = getClass().getClassLoader().getResource("com/angrysurfer/mildred/ui/javafx/MildredMonitorStage.fxml");
        Parent root = FXMLLoader.load(fxml);
        Scene scene = new Scene(root);
        stage. setScene(scene);
        stage.show();
    }
}
