package com.company.mildred.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true}")
@Table(name = "delimited_file_data")
@Entity(name = "mildred$DelimitedFileData")
public class DelimitedFileData extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = 6893699228111012984L;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "delimited_file_id")
    protected DelimitedFileInfo delimitedFile;

    @Column(name = "column_num", nullable = false)
    protected Integer columnNum;

    @Column(name = "row_num", nullable = false)
    protected Integer rowNum;

    @Column(name = "value", length = 256)
    protected String value;

    public void setDelimitedFile(DelimitedFileInfo delimitedFile) {
        this.delimitedFile = delimitedFile;
    }

    public DelimitedFileInfo getDelimitedFile() {
        return delimitedFile;
    }

    public void setColumnNum(Integer columnNum) {
        this.columnNum = columnNum;
    }

    public Integer getColumnNum() {
        return columnNum;
    }

    public void setRowNum(Integer rowNum) {
        this.rowNum = rowNum;
    }

    public Integer getRowNum() {
        return rowNum;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }


}