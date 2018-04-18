package com.angrysurfer.mildred.entity.media;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true}")
@Table(name = "delimited_file_info")
@Entity(name = "mildred$DelimitedFileInfo")
public class DelimitedFileInfo extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = 2151215700009381102L;

    @Column(name = "asset_id", nullable = false, length = 128)
    protected String asset;

    @Column(name = "delimiter", nullable = false, length = 1)
    protected String delimiter;

    @Column(name = "column_count", nullable = false)
    protected Integer columnCount;

    public void setAsset(String asset) {
        this.asset = asset;
    }

    public String getAsset() {
        return asset;
    }

    public void setDelimiter(String delimiter) {
        this.delimiter = delimiter;
    }

    public String getDelimiter() {
        return delimiter;
    }

    public void setColumnCount(Integer columnCount) {
        this.columnCount = columnCount;
    }

    public Integer getColumnCount() {
        return columnCount;
    }


}