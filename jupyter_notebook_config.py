# See http://jupyter-notebook.readthedocs.io/en/stable/config.html

from notebook.services.contents.filecheckpoints import FileCheckpoints


class NoCheckpoints(FileCheckpoints):
    def create_checkpoint(self, contents_mgr, path):
        pass

    def restore_checkpoint(self, contents_mgr, checkpoint_id, path):
        pass

    def rename_checkpoint(self, checkpoint_id, old_path, new_path):
        pass

    def delete_checkpoint(self, checkpoint_id, path):
        pass

    def list_checkpoints(self, path):
        return []

    def rename_all_checkpoints(self, old_path, new_path):
        """Rename all checkpoints for old_path to new_path."""
        pass

    def delete_all_checkpoints(self, path):
        """Delete all checkpoints for the given path."""
        pass


c.ContentsManager.checkpoints_class = NoCheckpoints
