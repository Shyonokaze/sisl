import numpy as np

from sisl import SislError
import sisl._array as _a
try:
    from . import _siesta
    found_module = True
except Exception as e:
    found_module = False

__all__ = ['_csr_from_siesta', '_csr_from_sc_off']
__all__ += ['_csr_to_siesta', '_csr_to_sc_off']


def _csr_from_siesta(geom, csr):
    """ Internal routine to convert *any* SparseCSR matrix from sisl nsc to siesta nsc """
    _csr_from_sc_off(geom, _siesta.siesta_sc_off(*geom.nsc).T, csr)


def _csr_to_siesta(geom, csr):
    """ Internal routine to convert *any* SparseCSR matrix from sisl nsc to siesta nsc """
    _csr_to_sc_off(geom, _siesta.siesta_sc_off(*geom.nsc).T, csr)


if not found_module:
    def _csr_from_siesta(geom, csr):
        raise SislError('sisl cannot convert the sparse matrix from a Siesta conforming sparsity pattern! Please install with fortran support!')

    def _csr_to_siesta(geom, csr):
        raise SislError('sisl cannot convert the sparse matrix into a Siesta conforming sparsity pattern! Please install with fortran support!')


def _csr_from_sc_off(geom, sc_off, csr):
    """ Internal routine to convert *any* SparseCSR matrix from sisl nsc to siesta nsc """
    nsc = geom.sc.nsc.astype(np.int32)
    sc = geom.sc.__class__([1], nsc=nsc)
    sc.sc_off = sc_off
    from_sc_off = sc.sc_index(geom.sc_off)
    # this transfers the local siesta csr matrix ordering to the geometry ordering
    col_from = (from_sc_off.reshape(-1, 1) * geom.no + _a.arangei(geom.no).reshape(1, -1)).ravel()
    _csr_from(col_from, csr)


def _csr_to_sc_off(geom, sc_off, csr):
    """ Internal routine to convert *any* SparseCSR matrix from sisl nsc to siesta nsc """
    # Find the equivalent indices in the geometry supercell
    to_sc_off = geom.sc_index(sc_off)
    # this transfers the local csr matrix ordering to the geometry ordering
    col_from = (to_sc_off.reshape(-1, 1) * geom.no + _a.arangei(geom.no).reshape(1, -1)).ravel()
    _csr_from(col_from, csr)


def _csr_from(col_from, csr):
    """ Internal routine to convert columns in a SparseCSR matrix """
    # local csr matrix ordering
    col_to = _a.arangei(csr.shape[1])
    csr.translate_columns(col_from, col_to)
