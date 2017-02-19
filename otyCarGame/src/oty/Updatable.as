package oty 
{
	
	/**
	 * Entidad actualizable.
	 * @author martin
	 */
	public interface Updatable 
	{
		/**
		 * Actualiza una entidad.
		 * @param	time Tiempo de actualizacion en milisegundos.
		 */
		function update(time:Number = 0):void;
	}
	
}