module io.github.lexa_bu.javafx_1 {
    requires javafx.controls;
    requires javafx.fxml;


    opens io.github.lexa_bu.javafx_1 to javafx.fxml;
    exports io.github.lexa_bu.javafx_1;
}