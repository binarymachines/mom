package com.angrysurfer.mildred.entity.media;

import com.haulmont.chile.core.datatypes.impl.EnumClass;

import javax.annotation.Nullable;


public enum AssetType implements EnumClass<String> {

    directory("directory"),
    file("file");

    private String id;

    AssetType(String value) {
        this.id = value;
    }

    public String getId() {
        return id;
    }

    @Nullable
    public static AssetType fromId(String id) {
        for (AssetType at : AssetType.values()) {
            if (at.getId().equals(id)) {
                return at;
            }
        }
        return null;
    }
}