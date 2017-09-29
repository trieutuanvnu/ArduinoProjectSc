package com.example.huylong.project_43;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.os.Handler;
import android.os.Vibrator;
import android.provider.Settings;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.support.v7.app.NotificationCompat;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ToggleButton;

import org.eclipse.paho.android.service.MqttAndroidClient;
import org.eclipse.paho.client.mqttv3.IMqttActionListener;
import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.IMqttToken;
import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;

import java.util.ArrayList;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;
import java.util.logging.LogRecord;

public class StatusActivity extends AppCompatActivity {

    SharedPreferences sharedPreferences;
    SharedPreferences.Editor editor;
    Vibrator vibe;

    Timer timer;
    TimerTask timerTask;

    final Handler handler = new Handler();

    static String MQTT_HOST = "tcp://m13.cloudmqtt.com:13910";
    static String topicStr = "control";

    static final int MY_NOTIFICATION_ID = 1000;
    static final int MY_REQUEST_CODE = 100;

    private NotificationCompat.Builder note;

    private String user;
    private String password;

    private TextView textViewSensor1Temp;
    private TextView textViewSensor1Humid;
    private TextView textViewSensor2Temp;
    private TextView textViewSensor2Humid;

    private ToggleButton toggleButtonFan;
    private ToggleButton toggleButtonLamp;

    private Spinner spinnerTempMin;
    private Spinner spinnerTempMax;
    private Spinner spinnerHumidMin;
    private Spinner spinnerHumidMax;

    private Integer tempMin;
    private Integer tempMax;
    private Integer humidMin;
    private Integer humidMax;

    private Integer currentTemp1;
    private Integer currentHumid1;
    private Integer currentTemp2;
    private Integer currentHumid2;

    private Integer currentTemp1Status = 0, lastTemp1Status = 0;
    private Integer currentTemp2Status = 0, lastTemp2Status = 0;
    private Integer currentHumid1Status = 0, lastHumid1Status = 0;
    private Integer currentHumid2Status = 0, lastHumid2Status = 0;

    private Button buttonLogout;

    MqttAndroidClient client;
    MqttConnectOptions options;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_status);

        sharedPreferences = getSharedPreferences("TEMP_HUMID_PREFS", Context.MODE_PRIVATE);
        editor = sharedPreferences.edit();

        tempMin = sharedPreferences.getInt("PREF_TEMP_MIN",0);
        tempMax = sharedPreferences.getInt("PREF_TEMP_MAX",0);
        humidMin = sharedPreferences.getInt("PREF_HUMID_MIN",0);
        humidMax = sharedPreferences.getInt("PREF_HUMID_MAX",0);

        note = new NotificationCompat.Builder(this);
        note.setAutoCancel(true);

        vibe = (Vibrator) getSystemService(Context.VIBRATOR_SERVICE);

        textViewSensor1Temp = (TextView) findViewById(R.id.tvSensor1Temp);
        textViewSensor1Humid = (TextView) findViewById(R.id.tvSensor1Humid);
        textViewSensor2Temp = (TextView) findViewById(R.id.tvSensor2Temp);
        textViewSensor2Humid = (TextView) findViewById(R.id.tvSensor2Humid);

        spinnerTempMin = (Spinner) findViewById(R.id.spTempMin);
        spinnerTempMax = (Spinner) findViewById(R.id.spTempMax);
        spinnerHumidMin = (Spinner) findViewById(R.id.spHumidMin);
        spinnerHumidMax = (Spinner) findViewById(R.id.spHumidMax);

        List<String> list = new ArrayList<String>();
        for (int i = 0; i <= 100; i++) {
            list.add(i,""+i);
        }

        ArrayAdapter<String> dataAdapter = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, list);
        dataAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

        spinnerTempMin.setAdapter(dataAdapter);
        spinnerTempMax.setAdapter(dataAdapter);
        spinnerHumidMin.setAdapter(dataAdapter);
        spinnerHumidMax.setAdapter(dataAdapter);

        spinnerTempMin.setSelection(tempMin);
        spinnerTempMax.setSelection(tempMax);
        spinnerHumidMin.setSelection(humidMin);
        spinnerHumidMax.setSelection(humidMax);

        spinnerTempMin.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                TextView tv = (TextView) view;
                Integer p = Integer.parseInt(tv.getText().toString());

                if (p >= Integer.parseInt(spinnerTempMax.getSelectedItem().toString())) {
                    p = Integer.parseInt(spinnerTempMax.getSelectedItem().toString()) - 1;
                }
                tempMin = p;
                editor.putInt("PREF_TEMP_MIN", p);
                editor.commit();
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });

        spinnerTempMax.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                TextView tv = (TextView) view;
                Integer p = Integer.parseInt(tv.getText().toString());

                if (p <= Integer.parseInt(spinnerTempMin.getSelectedItem().toString())) {
                    p = Integer.parseInt(spinnerTempMin.getSelectedItem().toString()) + 1;
                }
                tempMax = p;
                editor.putInt("PREF_TEMP_MAX", p);
                editor.commit();
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });

        spinnerHumidMin.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                TextView tv = (TextView) view;
                Integer p = Integer.parseInt(tv.getText().toString());

                if (p >= Integer.parseInt(spinnerHumidMax.getSelectedItem().toString())) {
                    p = Integer.parseInt(spinnerHumidMax.getSelectedItem().toString()) - 1;
                }
                humidMin = p;
                editor.putInt("PREF_HUMID_MIN", p);
                editor.commit();
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });

        spinnerHumidMax.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                TextView tv = (TextView) view;
                Integer p = Integer.parseInt(tv.getText().toString());

                if (p <= Integer.parseInt(spinnerHumidMin.getSelectedItem().toString())) {
                    p = Integer.parseInt(spinnerHumidMin.getSelectedItem().toString()) + 1;
                }
                humidMax = p;
                editor.putInt("PREF_HUMID_MAX", p);
                editor.commit();
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });

        buttonLogout = (Button) findViewById(R.id.btnLogout);

        buttonLogout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                disconnect();
            }
        });

        toggleButtonFan = (ToggleButton) findViewById(R.id.tbtnFan);
        toggleButtonFan.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String s = "";
                if (toggleButtonFan.isChecked())
                {
                    s = "RL1 OFF";
                }
                else
                {
                    s = "RL1 ON";
                }
                try {
                    client.publish(topicStr, s.getBytes(), 0, false);
                } catch (MqttException e) {
                    e.printStackTrace();
                }
            }
        });

        toggleButtonLamp = (ToggleButton) findViewById(R.id.tbtnLamp);
        toggleButtonLamp.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String s = "";
                if (toggleButtonLamp.isChecked())
                {
                    s = "RL2 OFF";
                }
                else
                {
                    s = "RL2 ON";
                }
                try {
                    client.publish(topicStr, s.getBytes(), 0, false);
                } catch (MqttException e) {
                    e.printStackTrace();
                }
            }
        });

        Intent intent = getIntent();
        user = intent.getStringExtra("User");
        password = intent.getStringExtra("Password");

        String clientId = MqttClient.generateClientId();
        client = new MqttAndroidClient(this.getApplicationContext(), MQTT_HOST, clientId);

        options = new MqttConnectOptions();
        options.setUserName(user);
        options.setPassword(password.toCharArray());

        try {
            IMqttToken token = client.connect(options);
            token.setActionCallback(new IMqttActionListener() {
                @Override
                public void onSuccess(IMqttToken asyncActionToken) {
                    // We are connected
                    Toast.makeText(StatusActivity.this, "Connected!", Toast.LENGTH_LONG);
                    setSubscription();
                    String s = "Start";
                    try {
                        client.publish(topicStr, s.getBytes(), 0, false);
                    } catch (MqttException e) {
                        e.printStackTrace();
                    }
                }

                @Override
                public void onFailure(IMqttToken asyncActionToken, Throwable exception) {
                    // Something went wrong e.g. connection timeout or firewall problems
                    back();
                }
            });
        } catch (MqttException e) {
            e.printStackTrace();
        }

        client.setCallback(new MqttCallback() {
            @Override
            public void connectionLost(Throwable cause) {

            }

            @Override
            public void messageArrived(String topic, MqttMessage message) throws Exception {
                String receivedMessage = new String(message.getPayload());
                String[] data = receivedMessage.split(", ");
                if (data[0].contains("Sen")) {
                    currentTemp1 = Integer.parseInt(data[1].toString());
                    currentHumid1 = Integer.parseInt(data[2].toString());
                    currentTemp2 = Integer.parseInt(data[3].toString());
                    currentHumid2 = Integer.parseInt(data[4].toString());

                    textViewSensor1Temp.setText(data[1] + "*C");
                    if (Integer.parseInt(data[1]) < tempMin) {
                        textViewSensor1Temp.setTextColor(Color.BLUE);
                    } else if (Integer.parseInt(data[1]) > tempMax) {
                        textViewSensor1Temp.setTextColor(Color.RED);
                    } else {
                        textViewSensor1Temp.setTextColor(Color.BLACK);
                    }

                    textViewSensor1Humid.setText(data[2] + "%");
                    if (Integer.parseInt(data[2]) < humidMin) {
                        textViewSensor1Humid.setTextColor(Color.BLUE);
                    } else if (Integer.parseInt(data[2]) > humidMax) {
                        textViewSensor1Humid.setTextColor(Color.RED);
                    } else {
                        textViewSensor1Humid.setTextColor(Color.BLACK);
                    }

                    textViewSensor2Temp.setText(data[3] + "*C");
                    if (Integer.parseInt(data[3]) < tempMin) {
                        textViewSensor2Temp.setTextColor(Color.BLUE);
                    } else if (Integer.parseInt(data[3]) > tempMax) {
                        textViewSensor2Temp.setTextColor(Color.RED);
                    } else {
                        textViewSensor2Temp.setTextColor(Color.BLACK);
                    }

                    textViewSensor2Humid.setText(data[4] + "%");
                    if (Integer.parseInt(data[4]) < humidMin) {
                        textViewSensor2Humid.setTextColor(Color.BLUE);
                    } else if (Integer.parseInt(data[4]) > humidMax) {
                        textViewSensor2Humid.setTextColor(Color.RED);
                    } else {
                        textViewSensor2Humid.setTextColor(Color.BLACK);
                    }
                }
                else if (data[0].contains("Rel"))
                {
                    if (data[1].contains("1"))
                    {
                        if (data[2].contains("1"))
                            toggleButtonFan.setChecked(true);
                        else if (data[2].contains("0"))
                            toggleButtonFan.setChecked(false);
                    }
                    else if (data[1].contains("2"))
                    {
                        if (data[2].contains("1"))
                            toggleButtonLamp.setChecked(true);
                        else if (data[2].contains("0"))
                            toggleButtonLamp.setChecked(false);
                    }
                }
                else if (data[0].contains("Res"))
                {
                    currentTemp1 = Integer.parseInt(data[1].toString());
                    currentHumid1 = Integer.parseInt(data[2].toString());
                    currentTemp2 = Integer.parseInt(data[3].toString());
                    currentHumid2 = Integer.parseInt(data[4].toString());

                    textViewSensor1Temp.setText(data[1] + "*C");
                    if (Integer.parseInt(data[1]) < tempMin) {
                        textViewSensor1Temp.setTextColor(Color.BLUE);
                    } else if (Integer.parseInt(data[1]) > tempMax) {
                        textViewSensor1Temp.setTextColor(Color.RED);
                    } else {
                        textViewSensor1Temp.setTextColor(Color.BLACK);
                    }

                    textViewSensor1Humid.setText(data[2] + "%");
                    if (Integer.parseInt(data[2]) < humidMin) {
                        textViewSensor1Humid.setTextColor(Color.BLUE);
                    } else if (Integer.parseInt(data[2]) > humidMax) {
                        textViewSensor1Humid.setTextColor(Color.RED);
                    } else {
                        textViewSensor1Humid.setTextColor(Color.BLACK);
                    }

                    textViewSensor2Temp.setText(data[3] + "*C");
                    if (Integer.parseInt(data[3]) < tempMin) {
                        textViewSensor2Temp.setTextColor(Color.BLUE);
                    } else if (Integer.parseInt(data[3]) > tempMax) {
                        textViewSensor2Temp.setTextColor(Color.RED);
                    } else {
                        textViewSensor2Temp.setTextColor(Color.BLACK);
                    }

                    textViewSensor2Humid.setText(data[4] + "%");
                    if (Integer.parseInt(data[4]) < humidMin) {
                        textViewSensor2Humid.setTextColor(Color.BLUE);
                    } else if (Integer.parseInt(data[4]) > humidMax) {
                        textViewSensor2Humid.setTextColor(Color.RED);
                    } else {
                        textViewSensor2Humid.setTextColor(Color.BLACK);
                    }

                    if (data[5].contains("1"))
                        toggleButtonFan.setChecked(true);
                    else if (data[5].contains("0"))
                        toggleButtonFan.setChecked(false);

                    if (data[6].contains("1"))
                        toggleButtonLamp.setChecked(true);
                    else if (data[6].contains("0"))
                        toggleButtonLamp.setChecked(false);

                    startTimer();
                }
            }

            @Override
            public void deliveryComplete(IMqttDeliveryToken token) {

            }
        });
    }

    private void startTimer()
    {
        timer = new Timer();
        timerTask = new TimerTask() {
            @Override
            public void run() {
                handler.post(new Runnable() {
                    @Override
                    public void run() {

                        String[] str = new String[4];
                        Integer numberString = 0;
                        if (currentTemp1 < tempMin)
                        {
                            str[numberString++] = "Sensor 1: Temperature's too low";
                            currentTemp1Status = 2;
                        }
                        else if (currentTemp1 > tempMax)
                        {
                            str[numberString++] = "Sensor 1: Temperature's too high";
                            currentTemp1Status = 1;
                        }
                        else
                        {
                            currentTemp1Status = 0;
                        }
                        if (currentHumid1 < humidMin)
                        {
                            str[numberString++] = "Sensor 1: Humid's too low";
                            currentHumid1Status = 2;
                        }
                        else if (currentHumid1 > humidMax)
                        {
                            str[numberString++] = "Sensor 1: Humid's too high";
                            currentHumid1Status = 1;
                        }
                        else
                        {
                            currentHumid1Status = 0;
                        }
                        if (currentTemp2 < tempMin)
                        {
                            str[numberString++] = "Sensor 2: Temperature's too low";
                            currentTemp2Status = 2;
                        }
                        else if (currentTemp2 > tempMax)
                        {
                            str[numberString++] = "Sensor 2: Temperature's too high";
                            currentTemp2Status = 1;
                        }
                        else
                        {
                            currentTemp2Status = 0;
                        }
                        if (currentHumid2 < humidMin)
                        {
                            str[numberString++] = "Sensor 2: Humid's too low";
                            currentHumid2Status = 2;
                        }
                        else if (currentHumid2 > humidMax)
                        {
                            str[numberString++] = "Sensor 2: Humid's too high";
                            currentHumid2Status = 1;
                        }
                        else
                        {
                            currentHumid2Status = 0;
                        }

                        if ((lastHumid1Status != currentHumid1Status)||(lastTemp1Status != currentTemp1Status)||(lastHumid2Status != currentHumid2Status)||(lastTemp2Status != currentTemp2Status))
                        {
                            lastTemp1Status = currentTemp1Status;
                            lastHumid1Status = currentHumid1Status;
                            lastTemp2Status = currentTemp2Status;
                            lastHumid2Status = currentHumid2Status;

                            if ((lastTemp1Status != 0)||(lastHumid1Status != 0)||(lastTemp2Status != 0)||(lastHumid2Status != 0))
                            {
                                noteExecute(str,numberString);
                                vibe.vibrate(500);
                            }
                        }

                    }
                });
            }
        };

        timer.schedule(timerTask, 1000, 1000);
    }

    private void stopTimer()
    {
        if (timer != null)
        {
            timer.cancel();
            timer = null;
        }
    }

    private void setSubscription()
    {
        try {
            client.subscribe(topicStr, 0);
        } catch (MqttException e) {
            e.printStackTrace();
        }
    }

    private void disconnect()
    {
        try {
            IMqttToken token = client.disconnect();
            token.setActionCallback(new IMqttActionListener() {
                @Override
                public void onSuccess(IMqttToken asyncActionToken) {
                    // We are connected

                }

                @Override
                public void onFailure(IMqttToken asyncActionToken, Throwable exception) {
                    // Something went wrong e.g. connection timeout or firewall problems


                }
            });
        } catch (MqttException e) {
            e.printStackTrace();
        }

        stopTimer();
        finish();
        Intent intent1 = new Intent(this,MainActivity.class);
        startActivity(intent1);
    }

    private void back()
    {
        finish();
        Intent intent1 = new Intent(this,MainActivity.class);
        intent1.putExtra("Failed","Connection failed");
        startActivity(intent1);
    }

    public void noteExecute(String[] str, Integer numberString)
    {
        this.note.setSmallIcon(R.mipmap.ic_launcher);
        this.note.setTicker("Warning");
        this.note.setContentTitle("Warning");
        this.note.setContentText("Warning");

        NotificationCompat.InboxStyle inboxStyle = new NotificationCompat.InboxStyle();

        inboxStyle.setBigContentTitle("Warning");

        for (int i = 0; i < numberString; i++)
        {
            inboxStyle.addLine(str[i]);
        }

        this.note.setStyle(inboxStyle);

        Intent intent = new Intent(this,StatusActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(this,MY_REQUEST_CODE,intent,PendingIntent.FLAG_UPDATE_CURRENT);

        this.note.setContentIntent(pendingIntent);

        NotificationManager notificationService = (NotificationManager) this.getSystemService(Context.NOTIFICATION_SERVICE);

        Notification notification = this.note.build();
        notificationService.notify(MY_NOTIFICATION_ID, notification);
    }
}
