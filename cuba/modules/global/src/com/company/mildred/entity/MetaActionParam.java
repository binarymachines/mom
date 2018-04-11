package com.company.mildred.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true}")
@Table(name = "meta_action_param")
@Entity(name = "mildred$MetaActionParam")
public class MetaActionParam extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = -2467234157585676626L;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "meta_action_id")
    protected MetaAction metaAction;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "vector_param_id")
    protected VectorParam vectorParam;

    public void setMetaAction(MetaAction metaAction) {
        this.metaAction = metaAction;
    }

    public MetaAction getMetaAction() {
        return metaAction;
    }

    public void setVectorParam(VectorParam vectorParam) {
        this.vectorParam = vectorParam;
    }

    public VectorParam getVectorParam() {
        return vectorParam;
    }


}