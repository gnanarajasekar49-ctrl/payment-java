package com.example;

public class PaymentApplication {

    public static String getVersion() {
        return "2.7";
    }

    public static String processPayment() {
        return "Payment processed successfully";
    }

    public static void main(String[] args) {
        System.out.println("Payment Application");
        System.out.println("Version: " + getVersion());
        System.out.println(processPayment());
    }
}
