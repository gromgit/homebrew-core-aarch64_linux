class Libmatroska < Formula
  desc "Extensible, open standard container format for audio/video"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libmatroska/libmatroska-1.6.2.tar.xz"
  sha256 "bc4479aa8422ab07643df6a1fa5a19e4bed4badfd41ca77e081628620d1e1990"
  license "LGPL-2.1"
  head "https://github.com/Matroska-Org/libmatroska.git"

  bottle do
    cellar :any
    sha256 "6a2ae9df8279bb33af3195baad983b9984b9d15e4102e1a8324f365c704aaa71" => :catalina
    sha256 "15ec15e52dfbab751edc3717e9486e8d1d86c27b9c11d191d7b4386da9719558" => :mojave
    sha256 "3951b56f6f095b6f4fd2fef10b73368294ed53755295bfc0349cb461d87014bc" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libebml"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=YES", *std_cmake_args
      system "make", "install"
    end
  end
end
