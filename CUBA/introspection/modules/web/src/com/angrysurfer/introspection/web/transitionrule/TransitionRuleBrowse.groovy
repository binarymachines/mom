package com.angrysurfer.introspection.web.transitionrule

import com.angrysurfer.introspection.entity.TransitionRule
import com.haulmont.cuba.core.entity.Entity
import com.haulmont.cuba.gui.components.*
import com.haulmont.cuba.gui.components.actions.CreateAction;
import com.haulmont.cuba.gui.components.actions.EditAction
import com.haulmont.cuba.gui.components.actions.RemoveAction
import com.haulmont.cuba.gui.data.CollectionDatasource
import com.haulmont.cuba.gui.data.DataSupplier
import com.haulmont.cuba.gui.data.Datasource

import javax.inject.Inject
import javax.inject.Named

class TransitionRuleBrowse extends AbstractLookup {

    /**
     * The {@link CollectionDatasource} instance that loads a list of {@link TransitionRule} records
     * to be displayed in {@link TransitionRuleBrowse#transitionRulesTable} on the left
     */
    @Inject
    private CollectionDatasource<TransitionRule, UUID> transitionRulesDs

    /**
     * The {@link Datasource} instance that contains an instance of the selected entity
     * in {@link TransitionRuleBrowse#transitionRulesDs}
     * <p/> Containing instance is loaded in {@link CollectionDatasource#addItemChangeListener}
     * with the view, specified in the XML screen descriptor.
     * The listener is set in the {@link TransitionRuleBrowse#init(Map)} method
     */
    @Inject
    private Datasource<TransitionRule> transitionRuleDs

    /**
     * The {@link Table} instance, containing a list of {@link TransitionRule} records,
     * loaded via {@link TransitionRuleBrowse#transitionRulesDs}
     */
    @Inject
    private Table<TransitionRule> transitionRulesTable

    /**
     * The {@link BoxLayout} instance that contains components on the left side
     * of {@link SplitPanel}
     */
    @Inject
    private BoxLayout lookupBox

    /**
     * The {@link BoxLayout} instance that contains buttons to invoke Save or Cancel actions in edit mode
     */
    @Inject
    private BoxLayout actionsPane

    /**
     * The {@link FieldGroup} instance that is linked to {@link TransitionRuleBrowse#transitionRuleDs}
     * and shows fields of the selected {@link TransitionRule} record
     */
    @Inject
    private FieldGroup fieldGroup
    
    /**
     * The {@link RemoveAction} instance, related to {@link TransitionRuleBrowse#transitionRulesTable}
     */
    @Named("transitionRulesTable.remove")
    private RemoveAction transitionRulesTableRemove
    
    @Inject
    private DataSupplier dataSupplier

    /**
     * {@link Boolean} value, indicating if a new instance of {@link TransitionRule} is being created
     */
    private boolean creating;

    @Override
    public void init(Map<String, Object> params) {

        /*
         * Adding {@link com.haulmont.cuba.gui.data.Datasource.ItemChangeListener} to {@link transitionRulesDs}
         * The listener reloads the selected record with the specified view and sets it to {@link transitionRuleDs}
         */
        transitionRulesDs.addItemChangeListener({def e ->
            if (e.getItem() != null) {
                TransitionRule reloadedItem = dataSupplier.reload(e.getDs().getItem(), transitionRuleDs.getView())
                transitionRuleDs.setItem(reloadedItem)
            }
        })
        
        /*
         * Adding {@link CreateAction} to {@link transitionRulesTable}
         * The listener removes selection in {@link transitionRulesTable}, sets a newly created item to {@link transitionRuleDs}
         * and enables controls for record editing
         */
        transitionRulesTable.addAction(new CreateAction(transitionRulesTable) {
            @Override
            protected void internalOpenEditor(CollectionDatasource datasource, Entity newItem, Datasource parentDs, Map<String, Object> openParams) {
                transitionRulesTable.setSelected(Collections.emptyList())
                transitionRuleDs.setItem((TransitionRule) newItem)
                refreshOptionsForLookupFields()
                enableEditControls(true)
            }
        })

        /*
         * Adding {@link EditAction} to {@link transitionRulesTable}
         * The listener enables controls for record editing
         */
        transitionRulesTable.addAction(new EditAction(transitionRulesTable) {
            @Override
            protected void internalOpenEditor(CollectionDatasource datasource, Entity existingItem, Datasource parentDs, Map<String, Object> openParams) {
                if (transitionRulesTable.getSelected().size() == 1) {
                    refreshOptionsForLookupFields()
                    enableEditControls(false)
                }
            }
        })
        
        /*
         * Setting {@link RemoveAction#afterRemoveHandler} for {@link transitionRulesTableRemove}
         * to reset record, contained in {@link transitionRuleDs}
         */
        transitionRulesTableRemove.setAfterRemoveHandler({def removedItems -> transitionRuleDs.setItem(null)})
        
        disableEditControls()
    }

    private void refreshOptionsForLookupFields() {
        for (Component component : fieldGroup.getOwnComponents()) {
            if (component instanceof LookupField) {
                CollectionDatasource optionsDatasource = ((LookupField) component).getOptionsDatasource()
                if (optionsDatasource != null) {
                    optionsDatasource.refresh()
                }
            }
        }
    }

    /**
     * Method that is invoked by clicking Save button after editing an existing or creating a new record
     */
    public void save() {
        if (!validate(Collections.singletonList(fieldGroup))) {
            return
        }
        getDsContext().commit()

        TransitionRule editedItem = transitionRuleDs.getItem()
        if (creating) {
            transitionRulesDs.includeItem(editedItem)
        } else {
            transitionRulesDs.updateItem(editedItem)
        }
        transitionRulesTable.setSelected(editedItem)

        disableEditControls()
    }

    /**
     * Method that is invoked by clicking Save button after editing an existing or creating a new record
     */
    public void cancel() {
        TransitionRule selectedItem = transitionRulesDs.getItem()
        if (selectedItem != null) {
            TransitionRule reloadedItem = dataSupplier.reload(selectedItem, transitionRuleDs.getView())
            transitionRulesDs.setItem(reloadedItem)
        } else {
            transitionRuleDs.setItem(null)
        }

        disableEditControls()
    }

    /**
     * Enabling controls for record editing
     * @param creating indicates if a new instance of {@link TransitionRule} is being created
     */
    private void enableEditControls(boolean creating) {
        this.creating = creating
        initEditComponents(true)
        fieldGroup.requestFocus()
    }

    /**
     * Disabling editing controls
     */
    private void disableEditControls() {
        initEditComponents(false)
        transitionRulesTable.requestFocus()
    }

    /**
     * Initiating edit controls, depending on if they should be enabled/disabled
     * @param enabled if true - enables editing controls and disables controls on the left side of the splitter
     *                if false - visa versa
     */
    private void initEditComponents(boolean enabled) {
        
            fieldGroup.setEditable(enabled)
        

        actionsPane.setVisible(enabled)
        lookupBox.setEnabled(!enabled)
    }
}