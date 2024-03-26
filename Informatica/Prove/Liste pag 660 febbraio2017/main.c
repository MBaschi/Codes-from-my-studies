
/*
 *  Create and display a binary search tree of integer keys.
 */

#include <stdio.h>
#include <stdlib.h>

#define TYPED_ALLOC(type) (type *)malloc(sizeof (type))

typedef struct tree_node_s {
    int                 key;
    struct tree_node_s *leftp, *rightp;
} tree_node_t;

tree_node_t *tree_insert(tree_node_t *rootp, int new_key);
//void tree_inorder(tree_node_t *rootp);

int
main(void)
{
    tree_node_t *bs_treep;   /* binary search tree     */
    int          data_key;   /* input - keys for tree      */
    int          status;     /* status of input operation    */
    
    bs_treep = NULL;   /* Initially, tree is empty */
    
    /* As long as valid data remains, scan and insert keys,
     displaying tree after each insertion. */
    for  (status = scanf("%d", &data_key);
          status == 1;
          status = scanf("%d", &data_key)) {
        bs_treep = tree_insert(bs_treep, data_key);
        printf("Tree after insertion of %d:\n", data_key);
        //tree_inorder(bs_treep);
    }
    
    if (status == 0) {
        printf("Invalid data >>%c\n", getchar());
    } else {
        printf("Final binary search tree:\n");
        //tree_inorder(bs_treep);
    }
    
    return (0);
}

/*
 *  Insert a new key in a binary search tree.  If key is a duplicate,
 *  there is no insertion.
 *  Pre:  rootp points to the root node of a binary search tree
 *  Post: Tree returned includes new key and retains binary
 *        search tree properties.
 */
tree_node_t *
tree_insert(tree_node_t *rootp,   /* input/output - root node of
                                   binary search tree    */
            int          new_key) /* input - key to insert */
{
    if (rootp == NULL) {             /* Simple Case 1 - Empty tree   */
        rootp = TYPED_ALLOC(tree_node_t);
        rootp->key = new_key;
        rootp->leftp = NULL;
        rootp->rightp = NULL;
    } else if (new_key == rootp->key) {             /* Simple Case 2 */
        /* duplicate key - no insertion                            */
    } else if (new_key < rootp->key) {              /* Insert in     */
        rootp->leftp = tree_insert                /* left subtree  */
        (rootp->leftp, new_key);
    } else {                  /* Insert in right subtree */
        rootp->rightp = tree_insert(rootp->rightp,
                                    new_key);
    }
    
    return (rootp);
}
