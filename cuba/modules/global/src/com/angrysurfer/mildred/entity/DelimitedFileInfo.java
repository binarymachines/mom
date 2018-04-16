package com.angrysurfer.mildred.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true}")
@Table(name = "delimited_file_info")
@Entity(name = "mildred$DelimitedFileInfo")
public class DelimitedFileInfo extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = -8408407462291504890L;

    @Column(name = "document_id", nullable = false, length = 128)
    protected String document;

    @Column(name = "delimiter", nullable = false, length = 1)
    protected String delimiter;

    @Column(name = "column_count", nullable = false)
    protected Integer columnCount;

    public void setDocument(String document) {
        this.document = document;
    }

    public String getDocument() {
        return document;
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