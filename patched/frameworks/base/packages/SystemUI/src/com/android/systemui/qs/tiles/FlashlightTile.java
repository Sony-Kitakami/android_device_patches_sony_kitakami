/*
 * Copyright (C) 2014 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License
 */

package com.android.systemui.qs.tiles;

import android.app.ActivityManager;

import com.android.internal.logging.MetricsLogger;
import com.android.systemui.R;
import com.android.systemui.qs.QSTile;
import com.android.systemui.statusbar.policy.FlashlightController;

import android.util.Log;

import java.io.*;

/** Quick settings tile: Control flashlight **/
public class FlashlightTile extends QSTile<QSTile.BooleanState> implements
        FlashlightController.FlashlightListener {

    private final AnimationIcon mEnable
            = new AnimationIcon(R.drawable.ic_signal_flashlight_enable_animation);
    private final AnimationIcon mDisable
            = new AnimationIcon(R.drawable.ic_signal_flashlight_disable_animation);
    private final FlashlightController mFlashlightController;

    public Boolean toggleState = new Boolean(null);

    /* Function : flashLightSwitch(boolean switchState) */
    /* Serves as an direct "Light Switch" by using /system/bin/torch-on or /system/bin/torch-off  which chainloads access to /sys/class/leds/torch-light1/brightness */
    public void flashLightSwitch(boolean switchState) 
    {
        try
        {
        
            if (switchState == true)
            {
                Log.i(TAG, "Torch ON");
                Runtime.getRuntime().exec( "torch-on" ); // Sets Torch ON
            }
            else
            {
                Log.i(TAG, "Torch OFF");             
                Runtime.getRuntime().exec( "torch-off" ); // Sets Torch OFF
            }

        } 
        
        catch (IOException e) 
        {
            System.err.println("Problem executing torch");
            Log.e(TAG, "IOException ERROR! Problem toggling torch");
        }
    }

    public boolean checkToggleState()
    {
        if (toggleState == false)
        {
            toggleState = true;
            return toggleState;
        }
        else if (toggleState = true)
        {
            toggleState = false;
            return toggleState;
        }
        else
        {
            toggleState = false;
            return toggleState;
        }
    }

    public FlashlightTile(Host host) {
        super(host);
        mFlashlightController = host.getFlashlightController();
        mFlashlightController.addListener(this);
    }

    @Override
    protected void handleDestroy() {
        super.handleDestroy();
        mFlashlightController.removeListener(this);
    }

    @Override
    protected BooleanState newTileState() {
        return new BooleanState();
    }

    @Override
    public void setListening(boolean listening) {
    }

    @Override
    protected void handleUserSwitch(int newUserId) {
    }

    @Override
    protected void handleClick() {
        if (ActivityManager.isUserAMonkey()) {
            return;
        }
        MetricsLogger.action(mContext, getMetricsCategory(), !mState.value);
        boolean newState = !mState.value;
        refreshState(newState ? UserBoolean.USER_TRUE : UserBoolean.USER_FALSE);
        mFlashlightController.setFlashlight(newState);
        checkToggleState ();
        if (checkToggleState() == false)
        {
            flashLightSwitch(false);
        }
        else if (checkToggleState() == true)
        {
            flashLightSwitch(true);
        }
    }

    @Override
    protected void handleUpdateState(BooleanState state, Object arg) {
        state.visible = true;
        state.label = mHost.getContext().getString(R.string.quick_settings_flashlight_label);
        if (arg instanceof UserBoolean) {
            boolean value = ((UserBoolean) arg).value;
            if (value == state.value) {
                return;
            }
            state.value = value;
        } else {
            state.value = mFlashlightController.isEnabled();
        }
        final AnimationIcon icon = state.value ? mEnable : mDisable;
        icon.setAllowAnimation(arg instanceof UserBoolean && ((UserBoolean) arg).userInitiated);
        state.icon = icon;
        int onOrOffId = state.value
                ? R.string.accessibility_quick_settings_flashlight_on
                : R.string.accessibility_quick_settings_flashlight_off;
        state.contentDescription = mContext.getString(onOrOffId);
    }

    @Override
    public int getMetricsCategory() {
        return MetricsLogger.QS_FLASHLIGHT;
    }

    @Override
    protected String composeChangeAnnouncement() {
        if (mState.value) {
            return mContext.getString(R.string.accessibility_quick_settings_flashlight_changed_on);
        } else {
            return mContext.getString(R.string.accessibility_quick_settings_flashlight_changed_off);
        }
    }

    @Override
    public void onFlashlightChanged(boolean enabled) {
        refreshState(enabled ? UserBoolean.BACKGROUND_TRUE : UserBoolean.BACKGROUND_FALSE);
    }

    @Override
    public void onFlashlightError() {
        refreshState(UserBoolean.BACKGROUND_FALSE);
    }

    @Override
    public void onFlashlightAvailabilityChanged(boolean available) {
        refreshState();
    }
}
