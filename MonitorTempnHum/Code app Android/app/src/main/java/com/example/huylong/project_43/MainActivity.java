package com.example.huylong.project_43;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.Checkable;
import android.widget.EditText;
import android.widget.Toast;

import org.eclipse.paho.android.service.MqttAndroidClient;
import org.eclipse.paho.client.mqttv3.IMqttActionListener;
import org.eclipse.paho.client.mqttv3.IMqttToken;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.eclipse.paho.client.mqttv3.MqttException;

public class MainActivity extends AppCompatActivity {

    SharedPreferences sharedPreferences;
    SharedPreferences.Editor editor;

    private EditText editTextUser;
    private EditText editTextPassword;
    private Button buttonLogIn;
    private CheckBox checkboxSaveLogin;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        editTextUser = (EditText) findViewById(R.id.edtUser);
        editTextPassword = (EditText) findViewById(R.id.edtPassword);
        buttonLogIn = (Button) findViewById(R.id.btnLogIn);
        checkboxSaveLogin = (CheckBox) findViewById(R.id.cbSaveLogin);

        sharedPreferences = getSharedPreferences("USER_PASS_PREFS", Context.MODE_PRIVATE);
        editor = sharedPreferences.edit();

        editTextUser.setText(sharedPreferences.getString("PREF_USER", ""));
        editTextPassword.setText(sharedPreferences.getString("PREF_PASS", ""));

        buttonLogIn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                login();
            }
        });
    }

    private void login()
    {
        String user = editTextUser.getText().toString().trim();
        String password = editTextPassword.getText().toString().trim();

        finish();
        Intent intent = new Intent(this,StatusActivity.class);
        intent.putExtra("User", user);
        intent.putExtra("Password", password);
        startActivity(intent);
    }

    protected void onPause() {
        super.onPause();

        if (!checkboxSaveLogin.isChecked())
        {
            editor.clear();
        }
        else
        {
            editor.putString("PREF_USER",editTextUser.getText().toString().trim());
            editor.putString("PREF_PASS",editTextPassword.getText().toString().trim());
            editor.putBoolean("PREF_CHECKED",checkboxSaveLogin.isChecked());
        }
        editor.commit();
    }

    protected void onResume()
    {
        super.onResume();

        boolean ischk = sharedPreferences.getBoolean("PREF_CHECKED", false);
        if (ischk)
        {
            String user = sharedPreferences.getString("PREF_USER","");
            String password = sharedPreferences.getString("PREF_PASS","");
            editTextUser.setText(user);
            editTextPassword.setText(password);
        }
        checkboxSaveLogin.setChecked(ischk);
    }
}
