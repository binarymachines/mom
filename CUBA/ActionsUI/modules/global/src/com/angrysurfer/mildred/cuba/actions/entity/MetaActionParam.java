package com.angrysurfer.mildred.cuba.actions.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import com.haulmont.cuba.core.entity.BaseIdentityIdEntity;

@DesignSupport("{'imported':true}")
@Table(name = "meta_action_param")
@Entity(name = "actionsui$MetaActionParam")
public class MetaActionParam extends BaseIdentityIdEntity {
    private static final long serialVersionUID = 6203537409237777124L;

    @Column(name = "vector_param_name", nullable = false, length = 128)
    protected String vectorParamName;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "meta_action_id")
    protected MetaAction metaAction;

    public void setVectorParamName(String vectorParamName) {
        this.vectorParamName = vectorParamName;
    }

    public String getVectorParamName() {
        return vectorParamName;
    }

    public void setMetaAction(MetaAction metaAction) {
        this.metaAction = metaAction;
    }

    public MetaAction getMetaAction() {
        return metaAction;
    }


}