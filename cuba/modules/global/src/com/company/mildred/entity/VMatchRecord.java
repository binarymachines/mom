package com.company.mildred.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import com.company.mildred.entity.key.VMatchRecordCompKey;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import com.haulmont.cuba.core.entity.BaseGenericIdEntity;

@DesignSupport("{'imported':true}")
@Table(name = "v_match_record")
@Entity(name = "mildred$VMatchRecord")
public class VMatchRecord extends BaseGenericIdEntity<VMatchRecordCompKey> {
    private static final long serialVersionUID = 6550061599877299267L;

    @Column(name = "comparison_result", nullable = false, length = 1)
    protected String comparisonResult;

    @Column(name = "is_ext_match", nullable = false)
    protected Integer isExtMatch;

    @EmbeddedId
    protected VMatchRecordCompKey id;

    public void setComparisonResult(String comparisonResult) {
        this.comparisonResult = comparisonResult;
    }

    public String getComparisonResult() {
        return comparisonResult;
    }

    public void setIsExtMatch(Integer isExtMatch) {
        this.isExtMatch = isExtMatch;
    }

    public Integer getIsExtMatch() {
        return isExtMatch;
    }

    @Override
    public VMatchRecordCompKey getId() {
        return id;
    }

    @Override
    public void setId(VMatchRecordCompKey id) {
        this.id = id;
    }


}