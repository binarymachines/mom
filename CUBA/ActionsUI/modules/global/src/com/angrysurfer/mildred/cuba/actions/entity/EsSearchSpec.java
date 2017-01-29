package com.angrysurfer.mildred.cuba.actions.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.chile.core.annotations.NamePattern;
import com.haulmont.cuba.core.global.DesignSupport;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import com.haulmont.cuba.core.entity.BaseIdentityIdEntity;

@DesignSupport("{'imported':true}")
@NamePattern("%s|name")
@Table(name = "es_search_spec")
@Entity(name = "actions$EsSearchSpec")
public class EsSearchSpec extends BaseIdentityIdEntity {
    private static final long serialVersionUID = -3567506242426526271L;

    @JoinTable(name = "es_search_field_jn",
        joinColumns = @JoinColumn(name = "es_search_spec_id"),
        inverseJoinColumns = @JoinColumn(name = "es_search_field_spec_id"))
    @ManyToMany
    protected List<EsSearchFieldSpec> esSearchFieldSpec;

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

    public void setEsSearchFieldSpec(List<EsSearchFieldSpec> esSearchFieldSpec) {
        this.esSearchFieldSpec = esSearchFieldSpec;
    }

    public List<EsSearchFieldSpec> getEsSearchFieldSpec() {
        return esSearchFieldSpec;
    }

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