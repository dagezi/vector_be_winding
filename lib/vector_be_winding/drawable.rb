require "rexml/document"

module VectorBeWinding
  class Drawable
    # A class to handle Android's vector drawable

    def read_from_file(filename)
      open(filename) { |inio|
        read(inio)
      }
    end

    def read(inio)
      @document = REXML::Document.new inio
    end

    def write_to_file(filename)
      open(filename, 'w') {|outio|
        write(outio)
      }
    end

    def write(outio)
      @document.write outio
    end

   def be_winding
      @document.each_recursive {|node|
        if node.name == 'path'
          pathString = node.attributes['android:pathData']
          path = Path.with_string(pathString)
          newPath = path.be_winding

          node.add_attribute('android:pathData', newPath.to_command)
        end
      }
    end

    def is_winding
      @document.each_recursive {|node|
        if node.name == 'path'
          pathString = node.attributes['android:pathData']
          path = Path.with_string(pathString)
          return false if !path.is_winding
        end
      }
      true
    end

    def dump
      @document.each_recursive {|node|
        if node.name == 'path'
          pathString = node.attributes['android:pathData']
          path = Path.with_string(pathString)
          puts "Path"
          path.dump(1)
        end
      }
    end
  end
end
