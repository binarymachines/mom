package com.angrysurfer.mildred.entity.media;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;
import com.haulmont.cuba.core.entity.annotation.Lookup;
import com.haulmont.cuba.core.entity.annotation.LookupType;

@DesignSupport("{'imported':true}")
@Table(name = "matcher_field")
@Entity(name = "mildred$MatcherField")
public class MatcherField extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = 6549471899406108525L;

    @Lookup(type = LookupType.DROPDOWN, actions = {"lookup", "open"})
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "matcher_id")
    protected Matcher matcher;

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

    public void setMatcher(Matcher matcher) {
        this.matcher = matcher;
    }

    public Matcher getMatcher() {
        return matcher;
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