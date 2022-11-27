class XercesC < Formula
  desc "Validating XML parser"
  homepage "https://xerces.apache.org/xerces-c/"
  url "https://www.apache.org/dyn/closer.lua?path=xerces/c/3/sources/xerces-c-3.2.3.tar.gz"
  mirror "https://archive.apache.org/dist/xerces/c/3/sources/xerces-c-3.2.3.tar.gz"
  sha256 "fb96fc49b1fb892d1e64e53a6ada8accf6f0e6d30ce0937956ec68d39bd72c7e"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/xerces-c"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "76efd599f281b3c0f0ab4cf2c9a18ec44c7884aff03fd96ba4426d7c3dc9b432"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make"
      system "ctest", "-V"
      system "make", "install"
      system "make", "clean"
      system "cmake", "..", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make"
      lib.install Dir["src/*.a"]
    end
    # Remove a sample program that conflicts with libmemcached
    # on case-insensitive file systems
    (bin/"MemParse").unlink
  end

  test do
    (testpath/"ducks.xml").write <<~EOS
      <?xml version="1.0" encoding="iso-8859-1"?>

      <ducks>
        <person id="Red.Duck" >
          <name><family>Duck</family> <given>One</given></name>
          <email>duck@foo.com</email>
        </person>
      </ducks>
    EOS

    output = shell_output("#{bin}/SAXCount #{testpath}/ducks.xml")
    assert_match "(6 elems, 1 attrs, 0 spaces, 37 chars)", output
  end
end
