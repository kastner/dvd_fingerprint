require 'digest/md5'

module DVDFingerprint
  extend self
  
  def generate_hash(string)
    md5 = Digest::MD5.hexdigest(string)
    md5.upcase.gsub(/(.{8})(.{4})(.{4})(.{4})(.*)/, '\1-\2-\3-\4-\5')
  end
  
  def get_paths(starting_path)
    Dir["#{starting_path}/VIDEO_TS/**/*"].map { |f| [f.gsub(/#{starting_path}/,''), File.size(f)].join(":")}
  end
  
  def combine_files(paths)
    paths.sort.join(":")
  end
  
  def fingerprint(path)
    paths = get_paths(path)
    string = combine_files(paths)
    generate_hash(string)
  end
end

if $0 == __FILE__
  require 'rubygems'
  require 'test/spec'
  
  def test_string
    ":/VIDEO_TS/VIDEO_TS.BUP:12288:/VIDEO_TS/VIDEO_TS.IFO:12288:/VIDEO_TS/VIDEO_TS.VOB:58052608:/VIDEO_TS/VTS_01_0.BUP:98304:/VIDEO_TS/VTS_01_0.IFO:98304:/VIDEO_TS/VTS_01_0.VOB:75163648:/VIDEO_TS/VTS_01_1.VOB:1073598464:/VIDEO_TS/VTS_01_2.VOB:1073448960:/VIDEO_TS/VTS_01_3.VOB:1073741824:/VIDEO_TS/VTS_01_4.VOB:1073647616:/VIDEO_TS/VTS_01_5.VOB:835813376"
  end
  
  def test_paths
    [
      "/VIDEO_TS/VIDEO_TS.BUP",
      "/VIDEO_TS/VIDEO_TS.IFO",
      "/VIDEO_TS/VIDEO_TS.VOB",
      "/VIDEO_TS/VTS_01_0.BUP",
      "/VIDEO_TS/VTS_01_0.IFO",
      "/VIDEO_TS/VTS_01_0.VOB",
      "/VIDEO_TS/VTS_01_1.VOB",
      "/VIDEO_TS/VTS_01_2.VOB",
      "/VIDEO_TS/VTS_01_3.VOB",
      "/VIDEO_TS/VTS_01_4.VOB",
      "/VIDEO_TS/VTS_01_5.VOB"
    ]
  end
  
  describe "The Doors DVD - already traversed" do
    it "should return the test hash" do
      DVDFingerprint.generate_hash(test_string).should == "2075AB92-06CD-ED43-A753-2B75627BE844"
    end
    
    it "should calculate the test string given the directory structure" do
      DVDFingerprint.combine_files(test_string).should == test_string
    end
  end
end

# puts DVDFingerprint.combine_files(DVDFingerprint.get_paths("/Volumes/DVD_VIDEO/"))
