class H3 < Formula
  desc "Hexagonal hierarchical geospatial indexing system"
  homepage "https://uber.github.io/h3/"
  url "https://github.com/uber/h3/archive/v3.7.1.tar.gz"
  sha256 "cfa3b4e1d46251929bd30575f09c89edb2c209be7ad8b0af15ff3f9a04132688"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "10d7a83009f264fec7eca8a137e7ca447d5d42014c6d462901be73e01fd44150" => :catalina
    sha256 "a9ae53d3e322038ca02c04b3d6a0cd077bfddcc20fe520fb13c7f1254d2c0b96" => :mojave
    sha256 "6bc0a20ee7598bce3815a952f9166c6239411c2fe651007fdcaeabfe1bc9b384" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=YES", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    result = pipe_output("#{bin}/geoToH3 -r 10 --lat 40.689167 --lon -74.044444")
    assert_equal "8a2a1072b59ffff", result.chomp
  end
end
