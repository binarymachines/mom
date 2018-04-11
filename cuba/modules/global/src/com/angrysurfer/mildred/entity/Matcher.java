package com.angrysurfer.mildred.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.chile.core.annotations.NamePattern;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true}")
@NamePattern("%s|name")
@Table(name = "matcher")
@Entity(name = "mildred$Matcher")
public class Matcher extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = 7478316667849401490L;

    @Column(name = "name", nullable = false, length = 128)
    protected String name;

    @Column(name = "query_type", nullable = false, length = 64)
    protected String queryType;

    @Column(name = "max_score_percentage", nullable = false)
    protected Double maxScorePercentage;

    @Column(name = "applies_to_file_type", nullable = false, length = 6)
    protected String appliesToFileType;

    @Column(name = "active_flag", nullable = false)
    protected Boolean activeFlag = false;

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setQueryType(String queryType) {
        this.queryType = queryType;
    }

    public String getQueryType() {
        return queryType;
    }

    public void setMaxScorePercentage(Double maxScorePercentage) {
        this.maxScorePercentage = maxScorePercentage;
    }

    public Double getMaxScorePercentage() {
        return maxScorePercentage;
    }

    public void setAppliesToFileType(String appliesToFileType) {
        this.appliesToFileType = appliesToFileType;
    }

    public String getAppliesToFileType() {
        return appliesToFileType;
    }

    public void setActiveFlag(Boolean activeFlag) {
        this.activeFlag = activeFlag;
    }

    public Boolean getActiveFlag() {
        return activeFlag;
    }


}