package com.angrysurfer.mildred.entity.elastic;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true}")
@Table(name = "clause")
@Entity(name = "mildred$Clause")
public class Clause extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = -1989991355660066090L;

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

    @Column(name = "section", length = 128)
    protected String querySection;

    @Column(name = "default_value", length = 128)
    protected String defaultValue;

    @JoinTable(name = "query_clause_jn",
        joinColumns = @JoinColumn(name = "clause_id"),
        inverseJoinColumns = @JoinColumn(name = "query_id"))
    @ManyToMany
    protected List<Query> query;

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

    public void setQuery(List<Query> query) {
        this.query = query;
    }

    public List<Query> getQuery() {
        return query;
    }


}