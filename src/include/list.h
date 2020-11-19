// LIST HEADER

#pragma once

#include "configuration.h"

namespace sqlcheck {

// LOGICAL DATABASE DESIGN

void CheckMultiValuedAttribute(Configuration& state,
                               const std::string& sql_statement,
                               bool& print_statement,
                               int line);

void CheckRecursiveDependency(Configuration& state,
                              const std::string& sql_statement,
                              bool& print_statement,
                               int line);

void CheckPrimaryKeyExists(Configuration& state,
                           const std::string& sql_statement,
                           bool& print_statement,
                               int line);

void CheckGenericPrimaryKey(Configuration& state,
                            const std::string& sql_statement,
                            bool& print_statement,
                               int line);

void CheckForeignKeyExists(Configuration& state,
                           const std::string& sql_statement,
                           bool& print_statement,
                               int line);

void CheckVariableAttribute(Configuration& state,
                            const std::string& sql_statement,
                            bool& print_statement,
                               int line);

void CheckMetadataTribbles(Configuration& state,
                           const std::string& sql_statement,
                           bool& print_statement,
                               int line);

// PHYSICAL DATABASE DESIGN

void CheckFloat(Configuration& state,
                const std::string& sql_statement,
                bool& print_statement,
                               int line);

void CheckValuesInDefinition(Configuration& state,
                             const std::string& sql_statement,
                             bool& print_statement,
                               int line);

void CheckExternalFiles(Configuration& state,
                        const std::string& sql_statement,
                        bool& print_statement,
                               int line);

void CheckIndexCount(Configuration& state,
                     const std::string& sql_statement,
                     bool& print_statement,
                               int line);

void CheckIndexAttributeOrder(Configuration& state,
                              const std::string& sql_statement,
                              bool& print_statement,
                               int line);

// QUERY

void CheckSelectStar(Configuration& state,
                     const std::string& sql_statement,
                     bool& print_statement,
                               int line);

void CheckJoinWithoutEquality(Configuration& state,
                              const std::string& sql_statement,
                              bool& print_statement,
                               int line);

void CheckNullUsage(Configuration& state,
                    const std::string& sql_statement,
                    bool& print_statement,
                               int line);

void CheckNotNullUsage(Configuration& state,
                       const std::string& sql_statement,
                       bool& print_statement,
                               int line);

void CheckConcatenation(Configuration& state,
                        const std::string& sql_statement,
                        bool& print_statement,
                               int line);

void CheckGroupByUsage(Configuration& state,
                       const std::string& sql_statement,
                       bool& print_statement,
                               int line);

void CheckOrderByRand(Configuration& state,
                      const std::string& sql_statement,
                      bool& print_statement,
                               int line);

void CheckPatternMatching(Configuration& state,
                          const std::string& sql_statement,
                          bool& print_statement,
                               int line);

void CheckSpaghettiQuery(Configuration& state,
                         const std::string& sql_statement,
                         bool& print_statement,
                               int line);

void CheckJoinCount(Configuration& state,
                         const std::string& sql_statement,
                         bool& print_statement,
                               int line);

void CheckDistinctCount(Configuration& state,
                        const std::string& sql_statement,
                        bool& print_statement,
                               int line);

void CheckImplicitColumns(Configuration& state,
                          const std::string& sql_statement,
                          bool& print_statement,
                               int line);

void CheckHaving(Configuration& state,
                 const std::string& sql_statement,
                 bool& print_statement,
                               int line);

void CheckNesting(Configuration& state,
                  const std::string& sql_statement,
                  bool& print_statement,
                               int line);

void CheckOr(Configuration& state,
             const std::string& sql_statement,
             bool& print_statement,
                               int line);

void CheckUnion(Configuration& state,
                const std::string& sql_statement,
                bool& print_statement,
                               int line);

void CheckDistinctJoin(Configuration& state,
                       const std::string& sql_statement,
                       bool& print_statement,
                               int line);

// APPLICATION

void CheckReadablePasswords(Configuration& state,
                            const std::string& sql_statement,
                            bool& print_statement,
                               int line);


}  // namespace machine
