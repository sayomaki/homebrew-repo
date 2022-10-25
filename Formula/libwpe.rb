class Libwpe < Formula
  desc "General-purpose library specifically developed for WPE-flavored port of WebKit"
  homepage "https://wpewebkit.org"
  url "https://wpewebkit.org/releases/libwpe-1.14.0.tar.xz"
  sha256 "c073305bbac5f4402cc1c8a4753bfa3d63a408901f86182051eaa5a75dd89c00"
  license "BSD-2-Clause"

  depends_on "cmake" => :build
  depends_on "libxkbcommon"
  depends_on :linux
  depends_on "mesa"

  def install
    mkdir "build" do
      system "cmake", *std_cmake_args, ".."
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("cat #{lib}/pkgconfig/wpe-1.0.pc").strip
  end
end
