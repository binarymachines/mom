package com.angrysurfer.mildred.cuba.actions.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import com.haulmont.cuba.core.entity.BaseIdentityIdEntity;

@DesignSupport("{'imported':true}")
@Table(name = "es_search_field_spec")
@Entity(name = "actionsui$EsSearchFieldSpec")
public class EsSearchFieldSpec extends BaseIdentityIdEntity {
    private static final long serialVersionUID = 3539653739516366065L;

    @JoinTable(name = "es_search_field_jn",
        joinColumns = @JoinColumn(name = "es_search_field_spec_id"),
        inverseJoinColumns = @JoinColumn(name = "es_search_spec_id"))
    @ManyToMany
    protected List<EsSearchSpec> esSearchSpec;

    @Column(name = "field_name", nullable = false, length = 128)
    protected String fieldName;

    @Column(name = "boost", nullable = false)
    protected Double boost;

    @Column(name = "bool_", length = 16)
    protected String bool;

    @Column(name = "operator", length = 16)
    protected String operator;

    @Column(name = "minimum_should_match", nullable = false)
    protected Double minimumShouldMatch;

    @Column(name = "analyzer", length = 64)
    protected String analyzer;

    @Column(name = "query_section", length = 128)
    protected String querySection;

    @Column(name = "default_value", length = 128)
    protected String defaultValue;

    public void setEsSearchSpec(List<EsSearchSpec> esSearchSpec) {
        this.esSearchSpec = esSearchSpec;
    }

    public List<EsSearchSpec> getEsSearchSpec() {
        return esSearchSpec;
    }

    public void setFieldName(String fieldName) {
        this.fieldName = fieldName;
    }

    public String getFieldName() {
        return fieldName;
    }

    public void setBoost(Double boost) {
        this.boost = boost;
    }

    public Double getBoost() {
        return boost;
    }

    public void setBool(String bool) {
        this.bool = bool;
    }

    public String getBool() {
        return bool;
    }

    public void setOperator(String operator) {
        this.operator = operator;
    }

    public String getOperator() {
        return operator;
    }

    public void setMinimumShouldMatch(Double minimumShouldMatch) {
        this.minimumShouldMatch = minimumShouldMatch;
    }

    public Double getMinimumShouldMatch() {
        return minimumShouldMatch;
    }

    public void setAnalyzer(String analyzer) {
        this.analyzer = analyzer;
    }

    public String getAnalyzer() {
        return analyzer;
    }

    public void setQuerySection(String querySection) {
        this.querySection = querySection;
    }

    public String getQuerySection() {
        return querySection;
    }

    public void setDefaultValue(String defaultValue) {
        this.defaultValue = defaultValue;
    }

    public String getDefaultValue() {
        return defaultValue;
    }


}