package com.pagesociety.persistence
{
    public interface EntityDefinitionProvider
    {
        function provideEntityDefinition(type:String):EntityDefinition;
        function provideEntityDefinitions():Array ; //Array<EntityDefinition>
    }
}