<?php

	// Created 2017-12-12 by Timothy Ryan Mendenhall, Metadata Librarian, Fordham University
	// Purpose: batch replace metadata in a CONTENTdm collection based on input from a tab-delimited file
	// The script builds on the sample PHP script from the OCLC CONTENTdm Catcher documentation
	
	// Set up error notification

	ini_set('display_errors',1);
	error_reporting(E_ALL);

	// Enter in the authentication information for your CONTENTdm instance and the alias of the collection

	$CATCHERURL = "https://worldcat.org/webservices/contentdm/catcher/6.0/CatcherService.wsdl";
	$CDMURL = "http://server17265.contentdm.oclc.org:8888/";
	$CDMUSERNAME = "timothyryan50";
	$CDMPASSWORD = "MyjDHa5q";
	$CDMLICENSE = "QZNTL-8AMXD-ZRZDS-UYE55";
	$CDMALIAS = "Hist";

	//----------------------------------------------------------------------------------------------
	//  create object to connect to Catcher web service then make calls
	//----------------------------------------------------------------------------------------------

	$catcherws = new SoapClient ($CATCHERURL);

	//load the tsv-reader function 
	// TRM: look into replacing this dependency, as it is "copyrighted" (sigh)

	require_once 'tsv-to-array_Catcher.php';

	//tsv-reader  opens up your file and converts it to an array

	$file = 'ControlledVocabUpdate.tsv';
	$data = tsv_to_array($file,array('header_row'=>true,'remove_header_row'=>true));

	//loop through tsv to create nested metadata arrays for Catcher

	foreach ($data as $records) {
		$metadataList = array();
		$key = array_keys($records);
		$totalFields = count($key);
		for ($i = 0; $i < $totalFields; $i++)
		{	
			$field = $key[$i];
			$value = $records[$field];
			$metadata = array('field' => strval($field), 'value' => strval($value));
			$metadataList[$i] = $metadata;

		}
		$metadataWrapper = array('metadataList' => $metadataList);

		// The following commented-out lines I keep in here in case I need to check the output of the metadataWrapper array

		//$serializedList = var_export($metadataWrapper);
		//file_put_contents('metadataList01.txt', $serializedList);
		//echo '<pre>'.print_r($metadataList,true).'</pre>';	

		// Post CONTENTdm Catcher edit transaction 
		
		$param = array
		(
			'action'=>'edit',
			'cdmurl'=>$CDMURL,
			'username'=>$CDMUSERNAME,
			'password'=>$CDMPASSWORD,
			'license'=>$CDMLICENSE,
			'collection'=>$CDMALIAS,
			'metadata'=>$metadataWrapper
		);
		$processEdit =  $catcherws->processCONTENTdm ($param);
		print ("<hr><b>Edit process:</b>");
		print ("<pre>");
		print (htmlentities ($processEdit->return));
		print ("</pre>");
		
	}	
?>